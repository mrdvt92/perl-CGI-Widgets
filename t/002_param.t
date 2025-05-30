# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 35;

BEGIN { use_ok( 'CGI' ); }
BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

$html=CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

my $cgi=CGI->new('year=2007;month=12;day=31;hour=23;minute=45;second=33;function=Excel');
isa_ok ($cgi, 'CGI');
$html=CGI::Widgets->new(cgi=>$cgi);
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');
my ($y, $m, $d)=$html->ymd;
is($y, "2007", '$html->ymd year');
is($m,   "12", '$html->ymd month');
is($d,   "31", '$html->ymd day');

($m, $d, $y)=$html->mdy;
is($y, "2007", '$html->ymd year');
is($m,   "12", '$html->ymd month');
is($d,   "31", '$html->ymd day');

is(($html->ymd)[0], "2007", '$html->ymd year');
is(($html->ymd)[1],   "12", '$html->ymd month');
is(($html->ymd)[2],   "31", '$html->ymd day');

is(($html->mdy)[2], "2007", '$html->mdy year');
is(($html->mdy)[0],   "12", '$html->mdy month');
is(($html->mdy)[1],   "31", '$html->mdy day');

is(scalar($html->mdy), "12/31/2007", '$html->mdy year scalar context');
is(scalar($html->ymd), "2007/12/31", '$html->ymd year scalar context');

is($html->function, "Excel", '$html->function');
is($html->function("Foo"), "Foo", '$html->function');
is($html->function, "Foo", '$html->function');
is($html->function(undef), "", '$html->function');
is($html->function, "", '$html->function');

is($html->hour,   "23", '$html->hour');
is($html->minute, "45", '$html->minute');
is($html->second, "33", '$html->second');

my ($h, $mi, $s)=$html->hms;
is($h, "23", '$html->hour');
is($mi,"45", '$html->minute');
is($s, "33", '$html->second');

is(scalar($html->hms), '23:45:33', 'scalar($html->hms)');
