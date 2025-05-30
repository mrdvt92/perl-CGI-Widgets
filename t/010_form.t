# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 9;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new;
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

diag(sprintf "CGI Version: %s", CGI->version);

my $enctype="multipart/form-data";

#if (CGI->version >= "3.15") {
#  $enctype="application/x-www-form-urlencoded";
#}

{
  my $form = $html->form("TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="post" action="" enctype="multipart/form-data">TEXT</form>}, "form simple");
}
{
  my $form = $html->form({-action=>"foobar.cgi"}, "TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="post" action="foobar.cgi" enctype="multipart/form-data">TEXT</form>}, "form action");
}
{
  my $form = $html->form({-method=>"GET"}, "TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="get" action="" enctype="$enctype">TEXT</form>}, "form get");
}
{
  my $form = $html->form({-method=>"POST"}, "TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="post" action="" enctype="multipart/form-data">TEXT</form>}, "form post");
}
{
  my $form = $html->form({-method=>"GET", -action=>"foo.cgi"}, "TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="get" action="foo.cgi" enctype="$enctype">TEXT</form>}, "form get action");
}
{
  my $form = $html->form({-method=>"POST", -action=>"foo.cgi"}, "TEXT");
  $form =~ s/[\n\r]//g;
  is($form, qq{<form method="post" action="foo.cgi" enctype="multipart/form-data">TEXT</form>}, "form post action");
}
