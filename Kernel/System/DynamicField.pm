# --
# Kernel/System/DynamicField.pm - DynamicFields configuration backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicField.pm,v 1.1 2011-08-16 20:53:21 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField;

use strict;
use warnings;

use YAML;
use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::DynamicField

=head1 SYNOPSIS

DynamicFields backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DynamicField object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;
    use Kernel::System::DB;
    use Kernel::System::DynamicField;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $CacheInternalObject = Kernel::System::CacheInternal->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DynamicFieldObject = Kernel::System::DynamicField->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        CacheInternalObject => $CacheInternalObject,
        DBObject            => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'DynamicField',
        TTL  => 60 * 60,
    );

    return $Self;
}

=item DynamicFieldAdd()

add new Dynamic Field config

returns id of new Dynamic field if successful or undef otherwise

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        Name                => 'NameForField',  # mandatory
        Type                => 'Text',          # mandatory, selects the DF backend to use for this field
                                                # 'text' 'date' 'int', 'text' as default
        Config              => $ConfigHashRef,  # it is stored on YAML format
        BelongsArticle      => '1',             # optional, 1 as default, set to 1 it belongs
                                                # to individual articles, otherwise to tickets
        ValidID         => 1,
        UserID          => 123,
    );

=cut

sub DynamicFieldAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Name Type Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # dump config as string
    my $Config = YAML::Dump( $Param{Config} );

    # belongs article
    my $BelongsArticle = $Param{BelongsArticle} || '1';

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO dynamic_field (name, article_field, field_type, config, ' .
            'valid_id, create_time, create_by, change_time, change_by)' .
            ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$BelongsArticle, \$Param{Type}, \$Config,
            \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    my $DynamicField = $Self->DynamicFieldGet(
        Name => $Param{Name},
    );

    my $ID = $DynamicField->{ID};

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    return $ID;
}

=item DynamicFieldGet()

get Dynamic Field attributes

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID       => 123,             # ID or Name must be provided
        Name    => 'DynamicField',
    );

    $DynamicField = {
        ID              => 123,
        Name            => 'NameForField',
        Type            => 'Text',
        Config          => $ConfigHashRef,
        BelongsArticle  => '1',
        ValidID         => 12,
        CreateTime      => '2011-02-08 15:08:00',
        ChangeTime      => '2011-02-08 15:08:00',
    };

=cut

sub DynamicFieldGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Name!' );
        return;
    }

    # check cache
    my $CacheKey;

    if ( $Param{ID} ) {
        $CacheKey = 'DynamicFieldGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'DynamicFieldGet::Name::' . $Param{Name};

    }
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        return $Cache;
    }

    my %Data;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, name, article_field, field_type, config, valid_id, create_time, change_time '
                .
                'FROM dynamic_field WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, name, field_type, article_field, config, valid_id, create_time, change_time '
                .
                'FROM gi_DynamicField_config WHERE name = ?',
            Bind => [ \$Param{Name} ],
        );
    }

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Config = YAML::Load( $Data[4] );

        %Data = (
            ID             => $Data[0],
            Name           => $Data[1],
            Type           => $Data[2],
            BelongsArticle => $Data[3],
            Config         => $Config,
            ValidID        => $Data[5],
            CreateTime     => $Data[6],
            ChangeTime     => $Data[7],
        );
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'DynamicField',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item DynamicFieldUpdate()

update Dynamic Field content into database

returns 1 on success or undef on error

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID              => 1234,                # mandatory
        Name            => 'DiferentName',      # mandatory
        Type            => 'Text',              # mandatory, selects the DF backend to use for this field
                                                # 'text' 'date' 'int', 'text' as default
        Config          => $NewConfigHashRef,   # it is stored on YAML format
        BelongsArticle  => '1',                 # optional, 1 as default, set to 1 it belongs
                                                # to individual articles, otherwise to tickets
        ValidID         => 1,
        UserID          => 123,
    );

=cut

sub DynamicFieldUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID Name Type Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # dump config as string
    my $Config = YAML::Dump( $Param{Config} );

    # belongs article
    my $BelongsArticle = $Param{BelongsArticle} || '1';

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE dynamic_field SET name = ?, article_field = ?, field_type = ?, '
            . ' config = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$BelongsArticle, \$Param{Type}, \$Config, \$Param{ValidID},
            \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    return 1;
}

=item DynamicFieldDelete()

delete a Dynamic field entry

returns 1 if successful or undef otherwise

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub DynamicFieldDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $DynamicField = $Self->DynamicFieldGet(
        ID => $Param{ID},
    );
    return if !IsHashRefWithData($DynamicField);

    # delete Dynamic field
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM dynamic_field WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    return 1;
}

=item DynamicFieldList()

get DynamicField list

    my $List = $DynamicFieldObject->DynamicFieldList();

    or

    my $List = $DynamicFieldObject->DynamicFieldList(
        Valid => 0, # optional, defaults to 1
    );

=cut

sub DynamicFieldList {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }
    my $CacheKey = 'DynamicFieldList::Valid::' . $Valid;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        return $Cache;
    }

    my %Data;

    my $SQL = 'SELECT id, name FROM dynamic_field';

    if ( !defined $Param{Valid} || $Param{Valid} eq 1 ) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    if (%Data) {

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'DynamicField',
            Key   => $CacheKey,
            Value => \%Data,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \%Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2011-08-16 20:53:21 $

=cut
