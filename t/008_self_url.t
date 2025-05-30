# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 25;

$ENV{"SCRIPT_NAME"}="/test.cgi";

BEGIN { use_ok( 'CGI' ); }
BEGIN { use_ok( 'CGI::Widgets' ); }

my $cgi=CGI->new('year=1969;month=11;day=19;hour=6;minute=53;second=21');
isa_ok ($cgi, 'CGI');
my $html=CGI::Widgets->new(cgi=>$cgi);
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

is($html->self_url, 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url(year=>2010), 'test.cgi?year=2010;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url, 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url(year=>2010, month=>12), 'test.cgi?year=2010;month=12;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url, 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url(foo=>"bar"), 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21;foo=bar', '$html->self_url');
is($html->self_url, 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url(year=>""), 'test.cgi?year=;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url, 'test.cgi?year=1969;month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');

#This test "reorders" the parameters so we test it last
is($html->self_url(year=>undef), 'test.cgi?month=11;day=19;hour=6;minute=53;second=21', '$html->self_url');
is($html->self_url, 'test.cgi?month=11;day=19;hour=6;minute=53;second=21;year=1969', '$html->self_url');


{
my $cgi=CGI->new('y=1;m=2;d=3');
isa_ok ($cgi, 'CGI');
my $html=CGI::Widgets->new(cgi=>$cgi);
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');
is($html->self_url, 'test.cgi?y=1;m=2;d=3', '$html->self_url');
is($html->self_url(map {$_=>$_} "a".."z"), 'test.cgi?y=y;m=m;d=d;a=a;b=b;c=c;e=e;f=f;g=g;h=h;i=i;j=j;k=k;l=l;n=n;o=o;p=p;q=q;r=r;s=s;t=t;u=u;v=v;w=w;x=x;z=z', '$html->self_url');
is($html->self_url, 'test.cgi?y=1;m=2;d=3', '$html->self_url');
$html->cgi->param(-name=>"m", -value=>"X");
is($html->self_url, 'test.cgi?y=1;m=X;d=3', '$html->self_url');
$html->cgi->delete(-name=>"m");
is($html->self_url, 'test.cgi?y=1;d=3', '$html->self_url');
is($html->self_url(qw{y Y m M d D}), 'test.cgi?y=Y;d=D;m=M', '$html->self_url');
}
