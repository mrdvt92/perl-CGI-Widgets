# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 38;

BEGIN { use_ok( 'CGI' ); }
BEGIN { use_ok( 'CGI::Widgets' ); }
my $html;
my $cgi;

#diag("Testing: a very important negative date date!");

$cgi=CGI->new('year=1969;month=11;day=19;hour=6;minute=53;second=21');
isa_ok ($cgi, 'CGI');
$html=CGI::Widgets->new(cgi=>$cgi);
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

ok(!defined($html->{"datetime"}), "Not defined yet");
is($html->year, "1969", '$html->year');
is($html->month,  "11", '$html->month');
is($html->day,    "19", '$html->day');
is($html->hour,   "06", '$html->hour');
is($html->minute, "53", '$html->minute');
is($html->second, "21", '$html->second');
isa_ok($html->dt, "DateTime");
is($html->dt->datetime, "1969-11-19T06:53:21", "DateTime as string");

#diag("Testing: 00:00:00");

$cgi=CGI->new('year=1969;month=11;day=19;hour=0;minute=0;second=0');
isa_ok ($cgi, 'CGI');
$html=CGI::Widgets->new(cgi=>$cgi);
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

ok(!defined($html->{"datetime"}), "Not defined yet");
is($html->year, "1969", '$html->year');
is($html->month,  "11", '$html->month');
is($html->day,    "19", '$html->day');
is($html->hour,   "00", '$html->hour');
is($html->minute, "00", '$html->minute');
is($html->second, "00", '$html->second');
isa_ok($html->dt, "DateTime");
is($html->dt->datetime, "1969-11-19T00:00:00", "DateTime as string");

$html=CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');
ok(!defined($html->{"datetime"}), "Not defined yet");
my $before=DateTime->now->truncate(to=>"second");
$html->dt;
my $after=DateTime->now->truncate(to=>"second");
ok(defined($html->{"datetime"}), "defined now");
isa_ok($html->dt, "DateTime");
SKIP: {
  skip "Object Creation was not fast enough for this test", 7,  unless $before == $after;
  cmp_ok($html->year,   '==', $before->year,     '$html->year');
  cmp_ok($html->month,  '==', $before->month,    '$html->month');
  cmp_ok($html->day,    '==', $before->day,      '$html->day');
  cmp_ok($html->hour,   '==', $before->hour,     '$html->hour');
  cmp_ok($html->minute, '==', $before->minute,   '$html->minute');
  cmp_ok($html->second, '==', $before->second,   '$html->second');
  is($html->dt->datetime,     $before->datetime, "DateTime as string");
}
