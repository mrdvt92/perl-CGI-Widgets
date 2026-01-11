#!/usr/bin/perl
use strict;
use warnings;
use CGI::Widgets;

=head1 NAME

CGI-Widgets-tab_group.pl - CGI::Widgets Example

=cut

my $html = CGI::Widgets->new(title=>"Tab Group Example");
$html->push(
            $html->tab_group([
                              {label=>"Tab One", content=>"Content 1"                      },
                              {label=>"Tab Two", content=>"Numbers: ". join(", ", 1 .. 200)},
                             ]),
            $html->tab_group([
                              {label=>"Tab Three", content=>"Content 3"},
                              {label=>"Tab Four" , content=>"Content 4"},
                             ]),
           );
print $html->render;
