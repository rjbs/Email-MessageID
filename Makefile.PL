use ExtUtils::MakeMaker;

WriteMakefile (
               AUTHOR        => 'Casey West <casey@geeknest.com>',
               ABSTRACT      => "Generate world unique message-ids",
               NAME          => 'Email::MessageID',
               PREREQ_PM     => {
                                 'Email::Address' => '1.80',
                                 'Sys::Hostname' => '1.1',
                                 'Test::More' => '0.47',
                                },
               VERSION_FROM  => 'lib/Email/MessageID.pm',
              );
