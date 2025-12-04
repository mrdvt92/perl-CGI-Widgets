# -*- perl -*-
use strict;
use warnings;
use Test::More tests => 14;

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new;
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

can_ok ($html, 'tile_group');
can_ok ($html, 'tile');

like($html->tile(), qr{\A\s*<div.*div>\s*\Z}s, 'tile');
like($html->tile_group(), qr{\A\s*<div.* />\s*\Z}s, 'empty tile group'); #empty tile group is just <div />
like($html->tile_group(''), qr{\A\s*<div.*div>\s*\Z}s, 'trivial tile group');
like($html->tile_group(map {$html->tile({href=>$_, image=>$_})} 1 .. 10), qr{\A\s*<div.*div>\s*\Z}s, 'tile group');

{
local $@;
my $return = eval{$html->tile('')};
my $error  = $@;
like($error, qr{Syntax}, 'tile with string instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tile(0)};
my $error  = $@;
like($error, qr{Syntax}, 'tile with string instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tile(\'')};
my $error  = $@;
like($error, qr{Syntax}, 'tile with scalar ref instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tile([])};
my $error  = $@;
like($error, qr{Syntax}, 'tile with array ref instead of hash');
#diag $error;
}
{
local $@;
my $return = eval{$html->tile(bless({}))}; #we might want to rethink this behavior
my $error  = $@;
like($error, qr{Syntax}, 'tile with object instead of hash');
#diag $error;
}
