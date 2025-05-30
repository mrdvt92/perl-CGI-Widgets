# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 36;

BEGIN { use_ok( 'CGI::Widgets' ); }
{

my $html=CGI::Widgets->new(cgi=>CGI->new("foo=++myfoo+%20;bar=mybar;baz=mybaz+%09;buz=++mybuz%0D%0A"));

is($html->cgi->param("foo"), "  myfoo  ",   '$html->param_trim');
is($html->cgi->param("bar"),   "mybar",     '$html->param_trim');
is($html->cgi->param("baz"),   "mybaz \t",  '$html->param_trim');
is($html->cgi->param("buz"), "  mybuz\r\n", '$html->param_trim');
is($html->cgi->param("nul"),    undef,      '$html->param_trim');

is($html->param_trim("foo"), "myfoo", '$html->param_trim');
is($html->param_trim("bar"), "mybar", '$html->param_trim');
is($html->param_trim("baz"), "mybaz", '$html->param_trim');
is($html->param_trim("buz"), "mybuz", '$html->param_trim');
is($html->param_trim("nul"),  undef,  '$html->param_trim');
is($html->param_trim("nul")||'',  '', '$html->param_trim');

is($html->param_trim("foo"), "myfoo", '$html->param_trim');
is($html->param_trim("bar"), "mybar", '$html->param_trim');
is($html->param_trim("baz"), "mybaz", '$html->param_trim');
is($html->param_trim("buz"), "mybuz", '$html->param_trim');

is($html->cgi->param("foo"), "myfoo", '$html->param_trim');
is($html->cgi->param("bar"), "mybar", '$html->param_trim');
is($html->cgi->param("baz"), "mybaz", '$html->param_trim');
is($html->cgi->param("buz"), "mybuz", '$html->param_trim');

}

{

my $html=CGI::Widgets->new(cgi=>CGI->new("foo=++myfoo+%20;bar=mybar;baz=mybaz+%09;buz=++mybuz%0D%0A"));

my ($foo, $bar, $baz, $buz)=$html->param_trim(qw{foo bar baz buz});

is($foo, "myfoo", '$html->param_trim');
is($bar, "mybar", '$html->param_trim');
is($baz, "mybaz", '$html->param_trim');
is($buz, "mybuz", '$html->param_trim');

is($html->cgi->param("foo"), "myfoo", '$html->param_trim');
is($html->cgi->param("bar"), "mybar", '$html->param_trim');
is($html->cgi->param("baz"), "mybaz", '$html->param_trim');
is($html->cgi->param("buz"), "mybuz", '$html->param_trim');

}

{

my $html=CGI::Widgets->new(cgi=>CGI->new("foo=++myfoo+%20;bar=mybar;baz=mybaz+%09;buz=++mybuz%0D%0A"));

$html->param_trim(qw{foo bar baz buz});

is($html->cgi->param("foo"), "myfoo", '$html->param_trim');
is($html->cgi->param("bar"), "mybar", '$html->param_trim');
is($html->cgi->param("baz"), "mybaz", '$html->param_trim');
is($html->cgi->param("buz"), "mybuz", '$html->param_trim');

}

{

my $html=CGI::Widgets->new(cgi=>CGI->new("foo=;bar"));

$html->param_trim(qw{foo bar});

is($html->cgi->param("foo"), "", '$html->param_trim');
is($html->cgi->param("bar"), "", '$html->param_trim');

}

{

my $html=CGI::Widgets->new(cgi=>CGI->new("foo=;bar"));

my ($foo, $bar)=$html->param_trim(qw{foo bar});

is($foo, "", '$html->param_trim');
is($bar, "", '$html->param_trim');

}
