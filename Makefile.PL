use strict;
use ExtUtils::MakeMaker;

WriteMakefile (
  AUTHOR        => 'Casey West <casey@geeknest.com>',
  ABSTRACT      => "Generate world unique message-ids",
  NAME          => 'Email::MessageID',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Email::Address' => '1.80',
    'Sys::Hostname'  => '1.1',
    'Test::More'     => '0.47',
  },
  VERSION_FROM  => 'lib/Email/MessageID.pm',
  (eval { ExtUtils::MakeMaker->VERSION(6.46) }
    ? (META_MERGE => {
        resources => {
          Repository => 'http://github.com/rjbs/email-messageid'
        }
      })
    : ()
  ),
);
