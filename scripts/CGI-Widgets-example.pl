#!/usr/bin/perl
use strict;
use warnings;
use CGI::Widgets;

=head1 NAME

CGI-Widgets-example.pl - CGI::Widgets Example

=cut

my $html = CGI::Widgets->new;
print $html->render;
