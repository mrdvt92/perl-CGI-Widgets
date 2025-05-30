package CGI::Widgets::Auth;
use strict;
use warnings;
use base qw{Package::New};

our $VERSION = '2.01';

=head1 NAME

CGI::Widgets::Auth - HTML auth for CGI::Widgets

=head1 SYNOPSIS

  use CGI::Widgets;
  my $html = CGI::Widgets->new();
  my $auth = $html->auth;

=head1 DESCRIPTION

=head1 USAGE

=head1 CONSTRUCTOR

=head2 new

  my $auth = CGI::Widgets->new->auth;

=head1 METHODS

=head1 METHODS (Current User)

These method are integrated with the Apache/mod_auth environemnt.

=head2 user

Retuns the value from the AUTHENTICATE_SAMACCOUNTNAME or REMOTE_USER environment variables.

  my $user=$html->auth->user;

=cut

sub user {
  my $self        = shift;
  $self->{'user'} = shift if @_;
  unless (defined($self->{'user'})) {
    $self->{'user'} = $ENV{"AUTHENTICATE_SAMACCOUNTNAME"} || #case from LDAP Authnz provider
                      $ENV{'REMOTE_USER'}                 || #case from Apache Authentication
                      '';
  }
  return $self->{'user'};
}

=head2 name

Returns the user's name from Active Directory which is stored in the AUTHENTICATE_NAME environment variable.

  my $name=$html->auth->name;

=cut

sub name {$ENV{"AUTHENTICATE_NAME"}||''};

=head2 email

Returns the user's mail from Active Directory which is stored in the AUTHENTICATE_MAIL environment variable.

  my $name=$html->auth->email;

=cut

sub email {$ENV{"AUTHENTICATE_MAIL"}||''};

=head1 COPYRIGHT and LICENSE

Copyright (c) 2025 Michael R. Davis

MIT

=cut

1;
