# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 7;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');
isa_ok ($html->auth, 'CGI::Widgets::Auth');

$ENV{'REMOTE_USER'}='MDAVIS';
$ENV{"AUTHENTICATE_EXTENSIONATTRIBUTE2"}="83";
$ENV{"AUTHENTICATE_MAIL"}=q{email@test.tld};
$ENV{"AUTHENTICATE_NAME"}=q{Michael R. Davis};
$ENV{"AUTHENTICATE_SAMACCOUNTNAME"}=q{mdavis};

is($html->auth->user,  "mdavis",             "auth->user");
is($html->auth->email, 'email@test.tld',      "auth->email");
is($html->auth->name,  'Michael R. Davis',      "auth->name");
