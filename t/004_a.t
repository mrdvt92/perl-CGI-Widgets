# -*- perl -*-
use strict;
use warnings;
use Test::More tests => 7;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html = CGI::Widgets->new();
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

SKIP:{
  skip "Environment CGI_WIGDETS_AUTHOR_TESTS not true", 4 unless $ENV{'CGI_WIGDETS_AUTHOR_TESTS'};

is($html->a("A"), "<a>A</a>", "Test A");
is($html->a({-name=>"B1"}, "B2"), '<a name="B1">B2</a>', "Test B");

my $C='<form method="post" action="script" enctype="multipart/form-data" style="display: inline; padding-right: 0.29em;" name="fXXX"><input type="hidden" name="a" value="1"  /><input type="hidden" name="a" value="2"  /><input type="hidden" name="a" value="3"  /><input type="hidden" name="b" value="4"  /><input type="hidden" name="b" value="5"  /><a href="javascript:document.fXXX.submit()">C</a></form>';
my $Ctest=$html->a({-href=>"script", -values=>[qw{a 1 a 2 a 3 b 4 b 5}]}, "C");
$Ctest=~s/[\n\r]//g;
$Ctest=~s/(["\.]f)\d+([\."])/$1XXX$2/g;
is($Ctest, $C, "Test C");

my $D='<form method="post" action="script" enctype="multipart/form-data" style="display: inline; padding-right: 0.29em;" name="fXXX"><input type="hidden" name="a" value="1"  /><input type="hidden" name="a" value="2"  /><input type="hidden" name="a" value="3"  /><a href="javascript:document.fXXX.submit()">D</a></form>';
my $Dtest=$html->a({-href=>"script", -values=>{a=>[1,2,3]}}, "D");
$Dtest=~s/[\n\r]//g;
$Dtest=~s/(["\.]f)\d+([\."])/$1XXX$2/g;
#diag($Dtest);
#diag($D);
is($Dtest, $D, "Test D");

}
