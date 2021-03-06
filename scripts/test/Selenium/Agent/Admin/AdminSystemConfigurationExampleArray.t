# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my @Tests = (
    {
        Name     => 'ExampleArray',
        Index    => 1,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },

            # check if remove buttons are hidden
            {
                ElementMissing => '.RemoveButton:visible',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => 'Default value',
            },
            {
                Clear => 1,
            },
            {
                Write => 'New item',
            },
            {
                Click => '.AddArrayItem',
            },

            # check if add button is hidden
            {
                ElementMissing => '.AddArrayItem:visible',
            },
            {
                Click => '.ArrayItem:nth-of-type(3) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Item 1',
            'New item',
        ],
    },
    {
        Name     => 'ExampleArrayCheckbox',
        Index    => 2,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input:nth-child(2)',
            },
            {
                ElementValue => 1,
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '1',
            '0',
        ],
    },
    {
        Name     => 'ExampleArrayDate',
        Index    => 3,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)',
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(3)').val(\"2016\")",
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Wait to load item
                Select => '.ArrayItem:nth-of-type(2) select:nth-child(1)',
            },
            {
                # select day (15) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05',
            '2016-12-15',
        ],
    },
    {
        Name     => 'ExampleArrayDate',
        Index    => 3,
        Commands => [
            {
                VerifiedGet => 'Action=AdminSystemConfigurationGroup;RootNavigation=GenericInterface',
            },
            {
                # Click on the GenericInterface link in navigation tree.
                Navigate => 'Sample',
            },
            {
                # Wait until screen is loaded.
                Select => 'select',
            },
            {
                # Scroll to the setting.
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple')[0].scrollIntoView(true);",
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # Wait until Datepicker is loaded.
                Select => '.ArrayItem:nth-of-type(1) .DatepickerIcon',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .DatepickerIcon',
            },
            {
                DatepickerDay => 10,
            },
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(2)',
            },
            {
                # Make sure that Datepicker is working (Day is updated).
                ElementValue => 10,
            },
            {
                # Discard changes
                Click => '.Cancel',
            },
        ],
        ExpectedResult => [
            '2016-05-05',
            '2016-12-15',
        ],
    },
    {
        Name     => 'ExampleArrayDateTime',
        Index    => 4,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)'
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },

            # check default hour
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(4)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(5)',
            },
            {
                ElementValue => '45',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # wait to init DatePicker
                Select => '.ArrayItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (15) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {

                # select hour (16) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(4)').val(\"16\")",
            },
            {
                # select minute (45) second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(5)').val(\"45\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05 02:02:00',
            '2016-12-15 16:45:00',
        ],
    },
    {
        Name     => 'ExampleArrayDirectory',
        Index    => 5,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc',
            '/usr',
        ],
    },
    {
        Name     => 'ExampleArrayEntity',
        Index    => 6,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => '3 normal',
            },
            {
                # Select "1 very low".
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"1 very low\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val() === '1 very low'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '3 normal',
            '1 very low',
        ],
    },
    {
        Name     => 'ExampleArrayFile',
        Index    => 7,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc/hosts',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc/hosts',
            '/etc/localtime',
        ],
    },
    {
        Name     => 'ExampleArrayFile',
        Index    => 7,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Write => '/usrfake#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                Click => '.Update',
            },
            {
                Click => '.Cancel',
            },
        ],
        ExpectedResult => [    # Error occured, nothing was changed
            '/etc/hosts',
            '/etc/localtime',
        ],
    },
    {
        Name     => 'ExampleArrayFrontendNavigation',
        Index    => 8,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(2) input',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) .Hash .HashItem:nth-of-type(4) .AddArrayItem',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(2) .Hash .HashItem:nth-of-type(4) .ArrayItem input',
            },
            {
                Write => 'admin',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Description'
                ,    # Wait for validation error (Description).
            },
            {
                Write => 'Description',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Link'
                ,    # Wait for validation error (Link).
            },
            {
                Write => 'Action=AgentTest;Subaction=Test',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#Name'
                ,    # Wait for validation error (Name).
            },
            {
                Write => 'Navigation name',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input.Error#ExampleArrayFrontendNavigation_Array2_Hash\\#\\#\\#NavBar'
                ,    # Wait for validation error (NavBar).
            },
            {
                Write => 'Customers',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.Error',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'AccessKey'   => '',
                'Block'       => '',
                'Description' => 'Description',
                "Group"       => [],
                "GroupRo"     => [],
                'Link'        => 'Action=AgentTest;Subaction=Test',
                'LinkOption'  => '',
                'Name'        => 'Test',
                'NavBar'      => 'Customers',
                'Prio'        => '200',
                'Type'        => '',
            },
            {
                'AccessKey'   => '',
                'Block'       => '',
                'Description' => 'Description',
                'Group'       => [
                    'admin'
                ],
                "GroupRo"    => [],
                'Link'       => 'Action=AgentTest;Subaction=Test',
                'LinkOption' => '',
                'Name'       => 'Navigation name',
                'NavBar'     => 'Customers',
                'Prio'       => '',
                'Type'       => '',
            },
        ],
    },
    {
        Name     => 'ExampleArrayPassword',
        Index    => 9,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input',
            },
            {
                ElementValue => 'Secret',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 2',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Password 1',
            'Password 2',
        ],
    },
    {
        Name     => 'ExampleArrayPerlModule',
        Index    => 10,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'Kernel::System::Log::SysLog',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"Kernel::System::Log::File\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'Kernel::System::Log::File'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'Kernel::System::Log::SysLog',
            'Kernel::System::Log::File',
        ],
    },
    {
        Name     => 'ExampleArraySelect',
        Index    => 11,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'option-2',
            },
            {
                # Select option-2.
                JS => "\$('.SettingsList li:nth-of-type(11) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"option-2\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.SettingsList li:nth-of-type(11) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'option-2'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'option-2',
            },
        ],
        ExpectedResult => [
            'option-1',
            'option-2',
        ],
    },
    {
        Name     => 'ExampleArrayTextarea',
        Index    => 12,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) textarea',
            },
            {
                ElementValue => 'Textarea content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'test content',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
        ],
        ExpectedResult => [
            'Content 1',
            'test content',
        ],
    },
    {
        Name     => 'ExampleArrayTimeZone',
        Index    => 13,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'UTC',
            },
            {
                # Select Europe/Berlin
                JS => "\$('.SettingsList li:nth-of-type(13) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val('Europe/Berlin')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.SettingsList li:nth-of-type(13) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val() === 'Europe/Berlin'",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'UTC',
            'Europe/Berlin',
        ],
    },
);

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration';

        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );

        $Self->True(
            $XMLLoaded,
            "Example XML loaded.",
        );

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfiguration.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration");

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaserFound = index( $Selenium->get_page_source(), 'supports versioning, rollback and' ) > -1;
        if ( !$OTRSBusinessIsInstalled ) {
            $Self->True(
                $OBTeaserFound,
                "OTRSBusiness teaser found on page",
            );
        }
        else {
            $Self->False(
                $OBTeaserFound,
                "OTRSBusiness teaser not found on page",
            );
        }

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        my $SelectedItem;
        my $AlertText;

        for my $Test (@Tests) {

            my $Prefix = ".SettingsList li:nth-of-type($Test->{Index}) .WidgetSimple";

            $Selenium->execute_script(
                "\$('$Prefix')[0].scrollIntoView(true);",
            );

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->execute_script("\$('$Prefix $Value').trigger('click')");
                    if ($AlertText) {
                        $Selenium->WaitFor(
                            AlertPresent => 1,
                        );

                        # Verify alert message.
                        $Self->Is(
                            $AlertText,
                            $Selenium->get_alert_text(),
                            "$Test->{Name} - Check alert text - $AlertText",
                        );

                        # Accept alert.
                        $Selenium->accept_alert();

                        # Reset alert text.
                        $AlertText = '';
                    }
                    else {
                        $Selenium->WaitFor(
                            Time       => 120,
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'Clear' ) {
                    $SelectedItem->clear();
                }
                elsif ( $CommandType eq 'Hover' ) {
                    my $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                    $Selenium->mouse_move_to_location( element => $SelectedItem );

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . ':visible").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );
                }
                elsif ( $CommandType eq 'ExpectAlert' ) {
                    $AlertText = $Value;
                }
                elsif ( $CommandType eq 'Write' ) {

                    $SelectedItem->send_keys($Value);
                }
                elsif ( $CommandType eq 'ElementValue' ) {

                    $Self->Is(
                        $SelectedItem->get_value(),
                        $Value,
                        "$Test->{Name} - Check if element value is OK.",
                    );
                }
                elsif ( $CommandType eq 'ElementMissing' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length == 0',
                    );
                }
                elsif ( $CommandType eq 'Select' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    # JS needs more escapes.
                    my $JSValue = $Value;
                    $JSValue =~ s{\\}{\\\\}g;

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $JSValue" . '").length',
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                }
                elsif ( $CommandType eq 'WaitForJS' ) {
                    $Selenium->WaitFor(
                        JavaScript => $Value,
                    );
                }
                elsif ( $CommandType eq 'VerifiedGet' ) {
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?$Value");
                }
                elsif ( $CommandType eq 'Navigate' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("li#' . $Value . ' > i").length',
                    );
                    $Selenium->find_element( "li#$Value > i", "css" )->click();
                }
                elsif ( $CommandType eq 'DatepickerDay' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $(".ui-datepicker-calendar:visible").length',
                    );

                    $Selenium->find_element( '//a[text()="' . $Value . '"]' )->click();
                    $Selenium->WaitFor(
                        JavaScript => 'return $(".ui-datepicker-calendar:visible").length == 0',
                    );
                }
            }

            # Compare results.
            my %Setting = $SysConfigObject->SettingGet(
                Name => $Test->{Name},
            );

            if ( $Test->{ExpectedResult} ) {

                $Self->IsDeeply(
                    $Setting{EffectiveValue},
                    $Test->{ExpectedResult},
                    "Test Effective value deeply for $Test->{Name}",
                );
            }
        }

        # Reload page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        # Check if there is notification.
        $Self->True(
            index( $Selenium->get_page_source(), 'You have undeployed settings, would you like to deploy them?' ) > -1,
            "Notification shown for undeployed settings."
        );

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CloudService > i:visible").length',
        );

        $Selenium->execute_script("\$('#CloudService > i').trigger('click')");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#ConfigTree ul > li:first > ul > li:first:visible").length',
        );

        # Check navigation for disabled nodes.
        my $NodeDisabled = $Selenium->execute_script(
            'return $("#ConfigTree ul > li:first > ul > li:first a").hasClass("jstree-disabled");',
        );

        $Self->True(
            $NodeDisabled,
            'Check if CloudService::Admin node is disabled.',
        );

        # Enable this block if you want to test it multiple times.
        my @TestNames;

        # Reset settings to Default.
        for my $Test (@Tests) {
            if ( !grep { $_ eq $Test->{Name} } @TestNames ) {
                my %Setting = $SysConfigObject->SettingGet(
                    Name      => $Test->{Name},
                    Translate => 0,
                );

                my $Guid = $SysConfigObject->SettingLock(
                    UserID    => 1,
                    DefaultID => $Setting{DefaultID},
                    Force     => 1,
                );
                $Self->True(
                    $Guid,
                    "Lock setting before reset($Test->{Name}).",
                );

                my $Success = $SysConfigObject->SettingReset(
                    Name              => $Test->{Name},
                    ExclusiveLockGUID => $Guid,
                    UserID            => 1,
                );
                $Self->True(
                    $Success,
                    "Setting $Test->{Name} reset to the default value.",
                );

                $SysConfigObject->SettingUnlock(
                    DefaultID => $Setting{DefaultID},
                );

                push @TestNames, $Test->{Name};
            }
        }
    }
);

1;
