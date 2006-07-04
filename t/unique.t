use Test::More qw[no_plan];

use_ok 'Email::MessageID';

my %ids;
for ( 1 .. (shift || 1000) ) {
    my $mid = Email::MessageID->new;
    isa_ok $mid, 'Email::Address';
    ok ! exists $ids{$mid->address}, "$mid unique";
    $ids{$mid->address}++;
}
