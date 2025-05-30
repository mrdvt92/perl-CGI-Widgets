# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 16;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new(ini_path=>'.');
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');
is($html->title,         'PerlTools', '$html->title');
is($html->title('TEST'), 'TEST',      'set $html->title');
is($html->title,         'TEST',      'get $html->title');

isa_ok ($html->auth, 'CGI::Widgets::Auth');
$ENV{'REMOTE_USER'}='mdavis';

$ENV{"AUTHENTICATE_EXTENSIONATTRIBUTE2"}="83";
$ENV{"AUTHENTICATE_MAIL"}=q{foo@bar.tdl};
$ENV{"AUTHENTICATE_MEMBEROF"}=q{};
$ENV{"AUTHENTICATE_NAME"}=q{Michael Davis};
$ENV{"AUTHENTICATE_SAMACCOUNTNAME"}=q{mdavis};

is($html->auth->user, 'mdavis', '$html->auth->user');
is($html->auth->user('user2'), 'user2', '$html->auth->user');
is($html->auth->user, 'user2', '$html->auth->user');
is($html->expires(), '+10m', '$html->expires()');
is($html->expires('+7d'), '+7d', q{$html->expires('+7d')});
is($html->expires(), '+7d', '$html->expires()');

is($html->refresh(), undef, '$html->refresh()');
is($html->refresh(60), '60', '$html->refresh(60)');

SKIP:{
  skip "Environment CGI_WIGDETS_AUTHOR_TESTS not true", 1 unless $ENV{'CGI_WIGDETS_AUTHOR_TESTS'};

my $output=q{<a target="_blank" href="http://maps.google.com/maps?q=39,-77%20%28Hello%29"><img border="0" src="images/mapicon.gif" /></a>};
is ($html->GooleMapLinkPoint(39,-77, "Hello"), $output, '$html->GooleMapLinkPoint');

}
