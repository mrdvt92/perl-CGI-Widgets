#!/usr/bin/perl
use strict;
use warnings;
use CGI::Widgets;

my $html   = CGI::Widgets->new(title=>"Example - Anchors");
my $script = "http://127.0.0.1/cgi-bin/rawread.cgi";
$html->push(
  $html->cgi->h1($html->title),
  $html->list(
    $html->a("nomimal case"),
    $html->a({-name=>"nohref"}, "no href case"),
    $html->a({-href=>"$script"}, "script only case"),
    $html->a({-href=>"$script?a=1"}, "simple param case"),
    $html->a({-href=>"$script?a=1#section"}, "simple param case with section"),
    $html->a({-href=>sprintf("$script?%s", join("&", map {"id=$_"} 1..500))}, "long href case"),
    $html->a({-href=>sprintf("$script?%s#section", join("&", map {"id=$_"} 1..500))}, "long href case with section"),
    $html->a({-href=>"$script",
              -values=>[qw{a 1 a 2 a 3 a 4 b 2 c 3}]}, "array ref values"),
    $html->a({-href=>"$script",
              -values=>{a=>[1..4], qw{b 2 c 3}}}, "hash ref values"),
  ),
);

print $html->render;
