use strict;
use warnings;
use Test::More tests => 2000;
use Email::MessageID;

my %ids;
for ( 1 .. (shift || 1000) ) {
    my $mid = Email::MessageID->new;
    isa_ok $mid, 'Email::MessageID';
    ok ! exists $ids{$mid->address}, "$mid unique";
    $ids{$mid->address}++;
}
