# -*- perl -*-
use strict;
use warnings;
use Test::More tests => 18;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html = CGI::Widgets->new;
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

can_ok ($html, 'tab_group');

like($html->tab_group(), qr{\A\s*<div.*div>\s*\Z}s, 'tab');
like($html->tab_group([]), qr{\A\s*<div.*div>\s*\Z}s, 'empty tab group');
like($html->tab_group([map {+{content=>"content $_"}} 1 .. 10]), qr{\A\s*<div.*div>\s*\Z}s, 'tab group');
{
  my $text = $html->tab_group([{content=>"a", label=>"A"}, {content=>"b", label=>"B"},]);
  #diag($text);
  like($text, qr/<input[^<>]*checked[^<>]*tab1[^<>]*>/, 'tab group');
  my @text = split /\b/, $text;
  is((grep {$_ eq 'checked'} @text), 2);
}
{
  my $text = $html->tab_group([{content=>"a", label=>"A", active=>0}, {content=>"b", label=>"B", active=>1},]);
  #diag($text);
  like($text, qr/<input[^<>]*checked[^<>]*tab2[^<>]*>/, 'tab group');
  my @text = split /\b/, $text;
  is((grep {$_ eq 'checked'} @text), 2);
}
{
  my $text = $html->tab_group([{content=>"a", label=>"A", active=>1}, {content=>"b", label=>"B", active=>1},]);
  #diag($text);
  like($text, qr/<input[^<>]*checked[^<>]*tab1[^<>]*>/, 'tab group');
  my @text = split /\b/, $text;
  is((grep {$_ eq 'checked'} @text), 2);
}

{
local $@;
my $return = eval{$html->tab_group('')};
my $error  = $@;
like($error, qr{Syntax}, 'tab with string instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tab_group(0)};
my $error  = $@;
like($error, qr{Syntax}, 'tab with string instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tab_group(\'')};
my $error  = $@;
like($error, qr{Syntax}, 'tab with scalar ref instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tab_group({})};
my $error  = $@;
like($error, qr{Syntax}, 'tab with array ref instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tab_group(bless([]))}; #we might want to rethink this behavior
my $error  = $@;
like($error, qr{Syntax}, 'tabe with object instead of hash');
#diag $error;
}
