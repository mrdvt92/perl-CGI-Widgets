# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 22;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');

is($html->trim("one"), "one", "trim simple");
is($html->trim(" one"), "one", "trim simple");
is($html->trim("one "), "one", "trim simple");
is($html->trim(" one "), "one", "trim simple");
is($html->trim("\tone"), "one", "trim simple");
is($html->trim("\tone\t"), "one", "trim simple");
is($html->trim("\t\n\tone\t\n\t"), "one", "trim multiple line");
is($html->trim(" \t \n \t one \t \n \t "), "one", "trim multiple line");

my @list=$html->trim("one", "two");
is($list[0], "one", "trim multiple args");
is($list[1], "two", "trim multiple args");
@list=$html->trim(" one ", " two ");
is($list[0], "one", "trim multiple args");
is($list[1], "two", "trim multiple args");
@list=$html->trim(" \tone\n", "\ntwo \t");
is($list[0], "one", "trim multiple args");
is($list[1], "two", "trim multiple args");

my $list=$html->trim("one", "two");
is($list->[0], "one", "trim multiple args");
is($list->[1], "two", "trim multiple args");
$list=$html->trim(" one ", " two ");
is($list->[0], "one", "trim multiple args");
is($list->[1], "two", "trim multiple args");
$list=$html->trim(" \tone\n", "\ntwo \t");
is($list->[0], "one", "trim multiple args");
is($list->[1], "two", "trim multiple args");
