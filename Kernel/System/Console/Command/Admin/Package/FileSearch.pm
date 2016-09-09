# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Package::FileSearch;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Find a file in an installed OTRS package.');
    $Self->AddArgument(
        Name        => 'search-path',
        Description => "Filename or path to search for.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Searching in installed OTRS packages...</yellow>\n");

    my $Hit      = 0;
    my $Filepath = $Self->GetArgument('search-path');

    PACKAGE:
    for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {

        # Just show if PackageIsVisible flag is enabled.
        if (
            defined $Package->{PackageIsVisible}
            && !$Package->{PackageIsVisible}->{Content}
            )
        {
            next PACKAGE;
        }
        for my $File ( @{ $Package->{Filelist} } ) {
            if ( $File->{Location} =~ m{\Q$Filepath\E}smx ) {
                print
                    "+----------------------------------------------------------------------------+\n";
                print "| File:        $File->{Location}\n";
                print "| Name:        $Package->{Name}->{Content}\n";
                print "| Version:     $Package->{Version}->{Content}\n";
                print "| Vendor:      $Package->{Vendor}->{Content}\n";
                print "| URL:         $Package->{URL}->{Content}\n";
                print "| License:     $Package->{License}->{Content}\n";
                print
                    "+----------------------------------------------------------------------------+\n";
                $Hit++;
            }
        }
    }
    if ($Hit) {
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->PrintError("File $Filepath was not found in an installed OTRS package.\n");
    return $Self->ExitCodeError();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut