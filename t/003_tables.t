# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 11;

$ENV{"SCRIPT_NAME"}="/test.cgi";

BEGIN { use_ok( 'CGI::Widgets' ); }
my $html=CGI::Widgets->new;
isa_ok ($html, 'CGI::Widgets');
isa_ok ($html->cgi, 'CGI');

SKIP:{
  skip "Environment CGI_WIGDETS_AUTHOR_TESTS not true", 8 unless $ENV{'CGI_WIGDETS_AUTHOR_TESTS'};


my @data=([qw{A B C}], [1,2,3], [2,1,2], [3,3,1]);

#my $table='<table border="1"><tr><td>A</td> <td>B</td> <td>C</td></tr> <tr><td>1</td> <td>2</td> <td>3</td></tr> <tr><td>2</td> <td>1</td> <td>2</td></tr> <tr><td>3</td> <td>3</td> <td>1</td></tr></table>';
my $table='<table bordercolordark="#ffffff" bordercolor="#f1f2ef" border="0" style="BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;" cellspacing="4" cellpadding="0" bordercolorlight="#ffffff"><tr><td width="100%"><table bgcolor="#D4D0C8" border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td><table border="0" cellpadding="3" width="100%"> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">A</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">B</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">C</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td></tr></table></td></tr></table></td></tr></table>';
is($html->table(@data), $table, '$html->table');
$table='<table bordercolordark="#ffffff" bordercolor="#f1f2ef" border="0" style="BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;" cellspacing="4" cellpadding="0" bordercolorlight="#ffffff"><tr><td width="100%"><table bgcolor="#D4D0C8" border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td><table border="0" cellpadding="3" width="100%"><tr><td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;">A</td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;">B</td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;">C</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td></tr></table></td></tr></table></td></tr></table>';
is($html->tablename(@data), $table, '$html->tablename');
$table='<table bordercolordark="#ffffff" bordercolor="#f1f2ef" border="0" style="BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;" cellspacing="4" cellpadding="0" bordercolorlight="#ffffff"><tr><td width="100%"><table bgcolor="#D4D0C8" border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td><table border="0" cellpadding="3" width="100%"><tr><td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=1">A</a></td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=-2">B</a>&nbsp;&#9650;</td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=3">C</a></td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td></tr></table></td></tr></table></td></tr></table>';
my $header=shift(@data);
is($html->cgi->param("sort.id"), undef, "sort.id start");
$html->paramsort("id", 2);
is($html->cgi->param("sort.id"), "2", "sort.id default sets undef");
$html->paramsort("id", 3);
is($html->cgi->param("sort.id"), "2", "sort.id default does not override");

is($html->tablenamesort("id", $header, @data), $table, 'tablenamesort +2');
$table='<table bordercolordark="#ffffff" bordercolor="#f1f2ef" border="0" style="BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;" cellspacing="4" cellpadding="0" bordercolorlight="#ffffff"><tr><td width="100%"><table bgcolor="#D4D0C8" border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td><table border="0" cellpadding="3" width="100%"><tr><td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=1"><a href="test.cgi?sort.id=1">A</a></a></td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=2"><a href="test.cgi?sort.id=-2">B</a>&nbsp;&#9650;</a>&nbsp;&#9660;</td> <td bgcolor="#F1F2EF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040;"><a href="test.cgi?sort.id=3"><a href="test.cgi?sort.id=3">C</a></a></td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">2</td></tr> <tr><td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">3</td> <td bgcolor="#FFFFFF" style="FONT: 11px verdana,tahoma,arial; COLOR: #404040">1</td></tr></table></td></tr></table></td></tr></table>';
$html->cgi->param(-name=>"sort.id", -value=>"-2");
is($html->cgi->param("sort.id"), "-2", "sort.id");
is($html->tablenamesort("id", $header, @data), $table, 'tablenamesort -2');

}
