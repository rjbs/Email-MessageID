use strict;
use warnings;
package Email::MessageID;
# ABSTRACT: Generate world unique message-ids.

use overload '""' => 'as_string', fallback => 1;

=head1 SYNOPSIS

  use Email::MessageID;

  my $mid = Email::MessageID->new->in_brackets;

  print "Message-ID: $mid\x0D\x0A";

=head1 DESCRIPTION

Message-ids are optional, but highly recommended, headers that identify a
message uniquely. This software generates a unique message-id.

=method new

  my $mid = Email::MessageID->new;

  my $new_mid = Email::MessageID->new( host => $myhost );

This class method constructs an L<Email::Address|Email::Address> object
containing a unique message-id. You may specify custom C<host> and C<user>
parameters.

By default, the C<host> is generated from C<Sys::Hostname::hostname>.

By default, the C<user> is generated using C<Time::HiRes>'s C<gettimeofday>
and the process ID.

Using these values we have the ability to ensure world uniqueness down to
a specific process running on a specific host, and the exact time down to
six digits of microsecond precision.

=cut

sub new {
    my ($class, %args) = @_;

    $args{user} ||= $class->create_user;
    $args{host} ||= $class->create_host;

    my $str = "$args{user}\@$args{host}";

    bless \$str => $class;
}

=method create_host

  my $domain_part = Email::MessageID->create_host;

This method returns the domain part of the message-id.

=cut

my $_SYS_HOSTNAME_LONG;
sub create_host {
    unless (defined $_SYS_HOSTNAME_LONG) {
      $_SYS_HOSTNAME_LONG = (eval { require Sys::Hostname::Long; 1 }) || 0;
      require Sys::Hostname unless $_SYS_HOSTNAME_LONG;
    }

    return $_SYS_HOSTNAME_LONG ? Sys::Hostname::Long::hostname_long()
                               : Sys::Hostname::hostname();
}

=method create_user

  my $local_part = Email::MessageID->create_user;

This method returns a unique local part for the message-id.  It includes some
random data and some predictable data.

=cut

my @CHARS = ('A'..'F','a'..'f',0..9);

my %uniq;

sub create_user {
    my $noise = join '',
                map {; $CHARS[rand @CHARS] } (0 .. (3 + int rand 6));

    my $t = time;
    my $u = exists $uniq{$t} ? ++$uniq{$t} : (%uniq = ($t => 0))[1];

    my $user = join '.', $t . $u, $noise, $$;
    return $user;
}

=method in_brackets

When using Email::MessageID directly to populate the C<Message-ID> field, be
sure to use C<in_brackets> to get the string inside angle brackets:

  header => [
    ...
    'Message-Id' => Email::MessageID->new->in_brackets,
  ],

Don't make this common mistake:

  header => [
    ...
    'Message-Id' => Email::MessageID->new->as_string, # WRONG!
  ],

=for Pod::Coverage address as_string host user

=cut

sub user { (split /@/, ${ $_[0] }, 2)[0] }
sub host { (split /@/, ${ $_[0] }, 2)[1] }

sub in_brackets {
    my ($self) = @_;
    return "<$$self>";
}

sub address {
    my ($self) = @_;
    return "$$self";
}

sub as_string {
    my ($self) = @_;
    return "$$self";
}

1;
