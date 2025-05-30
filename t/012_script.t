# -*- perl -*-

use strict;
use warnings;
use Test::HTML::Content tests => 10;
use Test::More;


BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new(ini_path=>'.');
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

no_tag($html->content, 'script', "no JavaScript Tag");

isa_ok($html->script("XXX;"), "ARRAY");

xpath_ok($html->content, '/html/head/script', "XXX;");

$html=CGI::Widgets->new(ini_path=>'.');
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

isa_ok($html->script({-src=>"/path/filename"}), "ARRAY");

xpath_ok($html->content, '/html/head/script', "");
