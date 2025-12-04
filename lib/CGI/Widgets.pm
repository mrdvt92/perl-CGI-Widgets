package CGI::Widgets;
use strict;
use warnings;
use 5.010; #for //
use base qw{Package::New Package::Role::ini};
use CGI qw{bgsound nobr};
use CGI::Carp qw(fatalsToBrowser);
use HTML::CalendarMonthSimple;
use DateTime;
use CGI::Widgets::Auth;
use URI;
use Sys::Hostname qw{};

our $VERSION = '2.02';
our $PACKAGE = __PACKAGE__;

BEGIN {
  sub _handler {
    my $message=shift;
# We cannot use CGI.pm here since it loads Carp which is trying to unload.
# Compile time errors are trapped as "Attempt to reload Carp/Heavy.pm aborted."
    print qq{<html>
  <head>
    <title>Error Page</title>
  </head>
  <body>
    <h3>The following error occurred...</h3>
    <pre>$message</pre>
  </body>
</html>
};
  }
  CGI::Carp::set_message(\&_handler);
}

=head1 NAME

CGI::Widgets - HTML website for CGI perl tools.

=head1 SYNOPSIS

  use CGI::Widgets;
  my $html=CGI::Widgets-new;
  print $html->render;

=head1 DESCRIPTION

This package is a wrapper around L<CGI>.  It provides a full featured menu environment for CGI scripts.

=head1 CONSTRUCTOR

=head2 new

  my $html = CGI::Widgets->new();

=head1 METHODS (OBJECT)

=head2 content

Returns HTML content.

=cut

sub content {
  my $self    = shift;
  my $focus   = $self->focus;
  my $onload  = "";
  $onload     = qq{document.getElementById('$focus').focus();} if $focus;
  $onload    .= $self->onload if defined($self->onload);
  my $Menu    = $self->_Menu;
  my $banner  = $self->banner;
  my $content = join "",
     $self->cgi->start_html(-title   => $self->title,
                            -bgcolor => "#FFFFFF",
                            -script  => scalar($self->script),
                            -encoding=> "",
                            -onload  => $onload),
      $self->cgi->table({-border=>0,
                         -bordercolor=>"#111111",
                         -cellpadding=>0,
                         -cellspacing=>0,
                         -style=>"BORDER-COLLAPSE: collapse",
                         -width=>"100%"},
       $self->cgi->Tr(
        (
          $Menu || $banner
          ? (
              $self->cgi->td({-valign=>"top", -width=>"200"},
                (
                  $banner
                  ? $self->cgi->a({-href=>"./"},
                     $self->cgi->img({-alt=>$self->title,
                                      -border=>0,
                                      -width=>$self->banner_width,
                                      -height=>$self->banner_height,
                                      -src=>$banner}, ),
                    )
                  : ()
                ),
                $Menu
              ),
              $self->cgi->td({-valign=>"top", -width=>"8"},
               '&nbsp;'
              )
            )
          : ()
        ),
        $self->cgi->td({-valign=>"top"},
         $self->frame($self->title => $self->_Content),
        ),
       ),
       $self->cgi->Tr(
        $self->cgi->td({-align=>"CENTER", -colspan=>($Menu || $banner ? 3 : 1)},
         $self->footer,
        ),
       ),
      ),
     $self->cgi->end_html,
     "\n";
  return $content;
}

=head2 content_minimal

=cut

sub content_minimal {
  my $self    = shift;
  my $focus   = $self->focus;
  my $onload  = "";
  $onload     = qq{document.getElementById('$focus').focus();} if $focus;
  $onload    .= $self->onload if defined($self->onload);
  my $content = join "",
                  $self->cgi->start_html(
                                         -title    => $self->title,
                                         -bgcolor  => "#FFFFFF",
                                         -script   => scalar($self->script),
                                         -encoding => "",
                                         -onload   => $onload
                                        ),
                  $self->_Content,
                  $self->cgi->end_html,
                  "\n";
  return $content;
}

=head2 render

Returns the entire HTML page with cgi header.

  print $html->render;

=cut

sub render {
  my $self=shift();
  my $content=$self->content;
  return join "", $self->_Header(-content_length=>length($content)), $content;
}

=head2 push

Pushes arguments on to the end of the content array.

=cut

sub push {
  my $self=shift();
  return CORE::push(@{$self->_Content}, @_);
}

=head2 unshift

Unshifts arguments on to the front of the content array.

=cut

sub unshift {
  my $self=shift();
  return unshift(@{$self->_Content}, @_);
}

=head2 cgi

Returns the CGI object which is constructed on initialization.

=cut

sub cgi {
  my $self=shift();
  $self->{'cgi'}=shift if @_;
  $self->{'cgi'}=CGI->new unless defined $self->{'cgi'};
  return $self->{'cgi'};
}

=head2 auth

Returns an CGI::Widgets::Auth object.

=cut

sub auth {
  my $self=shift;
  unless (defined($self->{'auth'})) {
    $self->{'auth'}=CGI::Widgets::Auth->new;
  }
  return $self->{'auth'};
}

=head2 title

Sets and returns the page title.

=cut

sub title {
  my $self=shift;
  $self->{'title'}=shift if @_;
  $self->{'title'}=$self->ini->val(Settings => title => 'CGI::Widgets Website')
    unless defined $self->{"title"};
  return $self->{'title'};
}

=head2 onload

Sets and returns the JavaScript in the onload event handler.

=cut

sub onload {
  my $self=shift();
  $self->{'onload'}=shift if @_;
  return $self->{'onload'};
}

=head2 script

  $html->script({-src=>"/js/ac.js"});
  $html->script("SomeJavaScriptFunction;");

=cut

sub script {
  my $self=shift;
  my @data=@_;
  $self->{"script"}=[] unless ref($self->{"script"}) eq "ARRAY";
  foreach my $data (@data) {
    CORE::push @{$self->{"script"}}, $data;
  }
  return wantarray ? @{$self->{"script"}} : $self->{"script"};
}

=head2 focus

Sets and returns the name of the JavaScript object that is to recieved focus on page load.

  $html->focus("mytextbox");

=cut

sub focus {
  my $self=shift;
  $self->{"focus"}=shift if @_;
  return $self->{"focus"};
}

=head2 footer

Sets and returns the HTML footer

=cut

sub footer {
  my $self          = shift;
  $self->{'footer'} = shift if @_;
  if ($self->copyright_owner and $self->support_email and !defined($self->{'footer'})) {
    my @footer        = ();
    CORE::push @footer, sprintf("Copyright &copy; %s %s", DateTime->now->year, $self->copyright_owner) if $self->copyright_owner;
    my $email         = $self->support_email;
    CORE::push @footer, sprintf("Support: %s", $self->cgi->a({-href=>"mailto:$email?subject=Website+Support"}, $email)) if $email;
    $self->{'footer'} = @footer ? $self->cgi->p(join($self->cgi->br, @footer)) : '';
  }
  $self->{'footer'} = '' unless defined $self->{'footer'};
  return $self->{'footer'};
}

=head2 copyright_owner

=cut

sub copyright_owner {
  my $self = shift();
  $self->{'copyright_owner'} = shift if @_;
  $self->{'copyright_owner'} = '' unless defined  $self->{'copyright_owner'};
  return $self->{'copyright_owner'};
}

=head2 support_email

=cut

sub support_email {
  my $self = shift();
  $self->{'support_email'} = shift if @_;
  $self->{'support_email'} = '' unless defined  $self->{'support_email'};
  return $self->{'support_email'};
}

=head2 banner

Sets and returns the HTML banner

=cut

sub banner {
  my $self=shift();
  $self->{'banner'}=shift if @_;
  $self->{'banner'}=$self->ini->val(Settings => banner => 'images/logo.png') unless defined $self->{'banner'};
  return $self->{'banner'};
}

=head2 banner_height

Default: 95

=cut

sub banner_height {
  my $self                 = shift();
  $self->{'banner_height'} = shift if @_;
  $self->{'banner_height'} = $self->ini->val(Settings => banner_height => 95)  unless defined $self->{'banner_height'};
  return $self->{'banner_height'};
}

=head2 banner_width

Default: 200

=cut

sub banner_width {
  my $self                = shift();
  $self->{'banner_width'} = shift if @_;
  $self->{'banner_width'} = $self->ini->val(Settings => banner_width => 200) unless defined $self->{'banner_width'};
  return $self->{'banner_width'};
}

=head2 expires

Sets and returns HTML page expire.  Format is passed to CGI->header(-expires=>$val);

  $self->expires("+10m");

  +30s                                30 seconds from now
  +10m                                ten minutes from now
  +1h                                 one hour from now
  -1d                                 yesterday (i.e. "ASAP!")
  now                                 immediately
  +3M                                 in three months
  +10y                                in ten years time
  Thursday, 25-Apr-1999 00:40:33 GMT  at the indicated time & date

=cut

sub expires {
  my $self=shift();
  $self->{'expires'}=shift if @_;
  $self->{'expires'}=$self->ini->val(Settings => expires => '+10m') unless defined $self->{'expires'};
  return $self->{'expires'};
}

=head2 refresh

  $html->refresh(60); #seconds
  $html->refresh('60; URL=http://www.cpan.org/'); #redirect

=cut

sub refresh {
  my $self=shift();
  $self->{'refresh'}=shift if @_;
  return $self->{'refresh'};
}

=head1 METHODS (HTML SHORTCUTS)

=head2 table

HTML short cut for a formatted table.

  my $table=$html->table([1], [2], [3]);

=cut

sub table {
  my $self=shift();
  return $self->tablename(undef, @_);
}

=head2 tablename

Returns an HTML table with the first row being formated for column names.

  my $output=$html->tablename([qw{Col1 Col2}], [qw{a1 a2}], [qw{b1 b2}]);

=cut

sub tablename {
  my $self   = shift;
  my $title  = shift;
  my @table  = @_; #isa ([]. [], ...)
  my $header = '';
  $header    = $self->cgi->Tr(
                 $self->cgi->td({-bgcolor=>"#F1F2EF",
                                 -style=>"FONT: 11px verdana,tahoma,arial; COLOR: #404040;"}, 
                                $title, 
                 ), 
               ) if defined $title; 
  no warnings 'uninitialized';
  return 
     $self->cgi->table({-border=>0,
                    -bordercolor=>"#f1f2ef",
                    -bordercolordark=>"#ffffff",
                    -bordercolorlight=>"#ffffff",
                    -cellpadding=>0,
                    -cellspacing=>4,
                    -style=>"BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;"}, 
      $self->cgi->Tr(
       $self->cgi->td({-width=>"100%"}, 
        $self->cgi->table({-bgcolor=>"#D4D0C8",
                       -border=>0,
                       -cellpadding=>0,
                       -cellspacing=>0,
                       -width=>"100%"}, 
         $self->cgi->Tr(
          $self->cgi->td(
           $self->cgi->table({-border=>0,
                          -cellpadding=>3,
                          -width=>"100%"}, 
            $header,
            $self->cgi->Tr([
              map {
                $self->cgi->td({-bgcolor=>"#FFFFFF",
                        -style=>"FONT: 11px verdana,tahoma,arial; COLOR: #404040"}, 
                  $_
                )
              } @table
            ]), 
           ), 
          ), 
         ), 
        ), 
       ), 
      ), 
     );

}

=head2 paramsort

This function returns the value in the "sort.id" parameter which is a non-zero integer that can be passed directly into the 
DBIx::Array->sqlarrayarraynamesort function.

  my $sort = $html->paramsort("t1", -1); #where "t1" is an id string for this table and "-1" is the default sort value.

=cut

sub paramsort {
  my $self    = shift;
  my $id      = shift;
  my $param   = join('.', sort=>$id);  #?sort.t1=-2;sort.t2=+3;...
  my $default = shift;
  my $value   = $self->cgi->param(-name=>join('.', sort=>$id));
  if ($default and not $self->cgi->param($param)) {
    $self->cgi->param(-name=>$param, -value=>$default);
  } 
  return $self->cgi->param($param);
}

=head2 tablenamesort

  print $html->tablenamesort("id", @data);
  print $html->tablenamesort("id",
          $sdb->sqlarrayarraynamesort(
            $sql, $html->paramsort("id"), @parameters));

=cut

sub tablenamesort {
  my $self    = shift;
  my $id      = shift;
  my $param   = join(".", sort=>$id);
  my $header  = shift;
  my $current = $self->cgi->param(-name=>$param);
  my $index   = 0;
  my $up      = '&nbsp;&#9650;';
  my $dn      = '&nbsp;&#9660;';
  foreach (@$header) {
    my $arrow = '';
    $index++;
    my $sort = $index;
    if ($current == $index) {
      $sort *= -1;
      $arrow = $up;
    }
    $arrow = $dn if $index == -1 * $current;
    $_ = join("", $self->cgi->a({-href => $self->self_url($param => $sort)}, $_), $arrow);
  }
  return $self->tablename($header, @_);
}

=head2 frame

HTML short cut for a table frame.

  my $frame = $html->frame('Title', 'Content');

=cut

sub frame {
  my $self    = shift();
  my $title   = shift();
  my $content = join("", @_);
  return join "",
     $self->cgi->table({-border=>0,
                    -bordercolor=>"#f1f2ef",
                    -bordercolordark=>"#ffffff",
                    -bordercolorlight=>"#ffffff",
                    -cellpadding=>0,
                    -cellspacing=>4,
                    -style=>"BORDER-COLLAPSE: collapse; margin-top: 3px; margin-bottom: 3px;",
                    -width=>"100%"}, 
      $self->cgi->Tr(
       $self->cgi->td({-width=>"100%"}, 
        $self->cgi->table({-bgcolor=>"#D4D0C8",
                       -border=>0,
                       -cellpadding=>0,
                       -cellspacing=>0,
                       -width=>"100%"}, 
         $self->cgi->Tr(
          $self->cgi->td(
           $self->cgi->table({-border=>0,
                          -cellpadding=>3,
                          -width=>"100%"}, 
            $self->cgi->Tr(
             $self->cgi->td({-bgcolor=>"#F1F2EF",
                         -style=>"FONT: 11px verdana,tahoma,arial; COLOR: #404040;",
                         -width=>"100%"}, 
              $self->cgi->center($title), 
             ), 
            ), 
            $self->cgi->Tr(
             $self->cgi->td({-bgcolor=>"#FFFFFF",
                         -style=>"FONT: 11px verdana,tahoma,arial; COLOR: #404040",
                         -width=>"100%"}, 
              $content,
             ), 
            ), 
           ), 
          ), 
         ), 
        ), 
       ), 
      ), 
     ); 
}

=head2 form

Returns the start_form and end_form tags.

  $html->form(@fields);
  $html->form(\%hash, @fields);
  $html->form({-multipart=>1}, @fields);

=cut

sub form {
  my $self           = shift;
  my $data           = {};
  $data              = shift if ref($_[0]) eq "HASH";
  $data->{"-action"} = $self->script_name unless exists $data->{"-action"};
  $data->{"-method"} = "POST"             unless exists $data->{"-method"};

  my $start_form     = "";
  if ($data->{"-method"} eq "GET") {
    $data->{"-enctype"} = undef;
    $start_form = $self->cgi->start_form(%$data);
  } else {
    $start_form = $self->cgi->start_multipart_form(%$data);
  }
  my @form = ($start_form, @_, $self->cgi->end_form);
  return wantarray ? @form : join("", @form);
}

=head2 script_name

Returns script basename which is implemented as 

  return $self->cgi->url(-relative=>1);

=cut

sub script_name {
  my $self = shift();
  return $self->cgi->url(-relative=>1);
}

=head2 hostname

Returns the hostname of the service running the script.

=cut

sub hostname {
  return Sys::Hostname::hostname;
}

=head2 list

Returns an unordered list.

=cut

sub list {
  my $self = shift();
  my @list = map {sprintf("&middot;&nbsp;%s", $_)} @_;
  return join($self->cgi->br, @list);
}

=head2 link

HTML shortcut for an anchor from a registered object.

  my $link=$html->link($object);

=cut

sub link {
  my $self = shift();
  my $obj  = shift();
  if (not defined($obj)) {
    return sprintf("Unknown: (%s)", ref($obj));
  }
}

=head2 a

Wrapper around CGI->a and ->form methods that supports href data that is greater than 2048 characters and can auto build POST links with parameter value lists.

  $html->a({-href=>$script,
            -values=>\@array}, "Text");
  $html->a({-href=>$script,
            -values=>\%hash},  "Text");

Examples

  $html->a("nomimal case")
  $html->a({-name=>"nohref"}, "no href case")
  $html->a({-href=>"script"}, "script only case")
  $html->a({-href=>"script?a=1"}, "simple param case")
  $html->a({-href=>"script?a=1#section"}, "simple param case with section")
  $html->a({-href=>sprintf("script?%s", join("&", map {"id=$_"} 1..500))}, "long href case")
  $html->a({-href=>sprintf("script?%s#section", join("&", map {"id=$_"} 1..500))}, "long href case with section")
  $html->a({-href=>"script", -values=>[qw{a 1 a 2 a 3 a 4 b 2 c 3}]}, "array ref values perserves order")
  $html->a({-href=>"script", -values=>{a=>[1..4], qw{b 2 c 3}}}, "hash ref values")

=cut

sub a {
  my $self  = shift();
  my $limit = 2048;       #MSIE max http://support.microsoft.com/kb/q208427/
  if (ref($_[0]) eq "HASH") {
    my $data = shift;
    if (defined($data->{"-values"})) {
      my $form   = sprintf("f%s", int(rand(10e8)));
      my @values = ();
      @values    = @{$data->{"-values"}} if ref($data->{"-values"}) eq "ARRAY";
      @values    = %{$data->{"-values"}} if ref($data->{"-values"}) eq "HASH";
      my $method = $data->{"-method"} || "POST";
      my @hidden = ();
      while (@values) {
        my $name  = shift(@values);
        my $value = shift(@values);
        CORE::push @hidden, $self->cgi->hidden(-name=>$name, -value=>$value, -override=>1);
      }
      return scalar(
             $self->form({-name=>$form,
                          -action=>$data->{"-href"},
                          -method=>$method,
                          -style=>"display: inline; padding-right: 0.29em;"},
                @hidden,
                $self->cgi->a({-href=>"javascript:document.$form.submit()"},@_),
             ));
    } else {                         #values not defined
      if (defined($data->{"-href"}) and length($data->{"-href"}) > $limit) {
        #get2post for a long url
        my $url   = URI->new($data->{"-href"});
        my @param = $url->query_form;
        $url->query(undef);
        my $href  = $url->as_string;
        die("Error: The href is greater than $limit characters")
          if length($href) > $limit;
        #recursive call
        return $self->a({-href=>$href, -values=>\@param}, @_);
      } else {
        return $self->cgi->a($data, @_);
      }
    }
  } else {
    return $self->cgi->a(@_);
  }
}

=head2 tile_group

A wrapper around CGI div to contain and tile group.

  $html->tile_group($html->tile(), $html->tile(), ...);

=cut

sub tile_group {
  return shift->cgi->div({-style=>'overflow: hidden; width: 100%'}, @_);
}

=head2 tile

Wrapper around div and img tags to create a floating clickable image tile

  $html->tile(
              {image=>"", width=>160, height=>120, href=>"", target=>"_blank", ...}, 
              "Hover Text" #used to set img title (for hover) and alt text
             )

  Note: image, width, and height are stripped and used for the tile and image construction all other properties are sent to the anchor element (e.g., href, id)

=cut

sub tile {
  my $self        = shift;
  my $hash        = shift // {}; #{href=>"", image=>$relative_path, width=>"", height=>""},
  die("Error: Syntax: html->tile({href=>'', image=>'', width=>160, height=>120})") unless ref($hash) eq 'HASH';
  my $width       = delete($hash->{'-width'})  || delete($hash->{'width'})  || 160;
  my $height      = delete($hash->{'-height'}) || delete($hash->{'height'}) || 120;
  my $src         = delete($hash->{'-image'})  || delete($hash->{'image'})  || $self->_tile_image_default;
  my $width_html  = sprintf('width: %spx', $width+6); #six was from experimentation
  my $padding_bottom_html = sprintf('padding-bottom: %spx', $height+6);
  my $text        = shift; #string for hover
  return $self->cgi->div({-style=>"$width_html; $padding_bottom_html; position: relative; float: left;"}, #double div required to support auto-wrapping on window resize
           $self->cgi->div({-style=>'background-color: #FFFFFF; position: absolute; left: 1px; right: 1px; top: 1px; bottom: 1px; padding: 1px; border: 1px solid; border-color: #D9D9D9; border-radius: 14px; overflow: hidden'}, #14px was from experimentation
             $self->cgi->a($hash,
               $self->cgi->img({-src=>$src, -alt=>$text, -title=>$text, -width=>$width, -height=>$height}),
             ),
           ),
         );
}

#head2 _tile_image_default
#
# This can be overloaded in a sub class if you want a different default tile image.
#
#cut

sub _tile_image_default {
  return q{data:image/png;base64,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};
}

=head2 checkbox

CGI checkbox pass through with checkall property

=cut

our $CHECK_BOX_ID = 0;

sub checkbox {
  my $self     = shift;
  my %opt      = @_;
  $CHECK_BOX_ID++;
  my $id       = $opt{'-id'} ||= "auto" . $CHECK_BOX_ID;
  my $name     = delete($opt{'-checkall'});
  if ($name and $id) {
    $self->{'_checkall_data'}->{$name} ||= [];
    CORE::push @{$self->{'_checkall_data'}->{$name}}, $id;
  }
  return $self->cgi->checkbox(%opt);
}

=head2 checkall

CGI check box with specified checkall group

=cut

sub checkall {
  my $self         = shift;
  my %opt          = @_;
  my $name         = $opt{'-name'} or die("Package: $PACKAGE,  Method: checkall, Property -name required");
  my $list         = $self->{'_checkall_data'}->{$name} || [];
  my $onclick      = join " ", map {"$_.checked=this.checked;"} @$list;
  $opt{'-onclick'} = $onclick if $onclick;
  return $self->cgi->checkbox(%opt);
}

=head2 self_url

Return a URL with correct state preserved.

  my $url = $html->self_url;               #returns relative URL with current state
  my $url = $html->self_url(key=>"value"); #returns relative URL with query overridden with key value pairs.
  
Note: CGI->self_url returns full URLs which is not compatible with an https to http reverse proxy.

=cut

sub self_url {
  my $self  = shift;
  my @param = @_;
  my %reset = ();
  my @reset = (); #preserve order to help with browser cacheing
  while (@param) {
    my $key      = shift(@param);
    my $value    = shift(@param);
    $reset{$key} = $self->cgi->param(-name=>$key);
    CORE::push @reset, $key;
    if (defined $value) {
      $self->cgi->param(-name=>$key, -value=>$value);
    } else {
      $self->cgi->delete(-name=>$key);
    }
  }
  my $url = $self->cgi->url(-path_info=>1, -query=>1, -relative=>1);
  foreach my $key (@reset) {
    if (defined($reset{$key})) {
      $self->cgi->param(-name=>$key, -value=>$reset{$key});
    } else {
      $self->cgi->delete(-name=>$key);
    }
  }
  return $url;
}

=head2 cal

Returns an HTML calendar with links that preserve state.

  print $html->cal;
  print $html->cal(highlight=>[1,2,3,4]);

=cut

sub cal {
  my $self=shift;
  my $opt={@_};
  $opt->{'highlight'}=[] unless ref($opt->{'highlight'}) eq 'ARRAY';
  my ($year, $month, $day)=$self->ymd();

  my $cal=HTML::CalendarMonthSimple->new(year=>$year, month=>$month);

  $cal->width(240);
  $cal->saturday('S');
  $cal->sunday('S');
  $cal->weekdays(qw{M T W T F});
  $cal->vcellalignment('middle');
  $cal->cellalignment('center');
  foreach (@{$opt->{'highlight'}}) {
    $cal->datebordercolor($_, "#2E2E2E");
    $cal->datecolor($_, "#FEFEE2");
  }
  $cal->datecolor($day, "#D0D0D0"); #today

  my $next=$self->datetime->clone->add(months=>1, end_of_month=>"limit");
  my $prev=$self->datetime->clone->add(months=>-1, end_of_month=>"limit");

  $cal->header(
    $self->cgi->table({-width=>'100%'},
      $self->cgi->Tr(
        $self->cgi->td({-align=>"center"}, [
          $self->cgi->a({-href=>$self->self_url(year  => $prev->year,
                                                month => sprintf("%02d", $prev->month),
                                                day   => sprintf("%02d", $prev->day)),
                         -title=>$prev->month_name}, "&lt;"),
          $self->cgi->font({-size=>'+1'}, join(" ", $cal->monthname, $cal->year)),
          $self->cgi->a({-href=>$self->self_url(year  => $next->year,
                                                month => sprintf("%02d", $next->month),
                                                day   => sprintf("%02d", $next->day)),
                         -title=>$next->month_name}, "&gt;")]))));

  foreach (1 .. $cal->Days_in_Month) {
    $cal->setdatehref($_, $self->self_url(year  => $year,
                                          month => sprintf("%02d", $month),
                                          day   => sprintf("%02d", $_)));
  }

  return $cal->as_HTML;
}

=head2 clock

=cut

sub clock {
  my $self=shift;
  my @data=($self->clockhour, $self->clockminute);
  return wantarray ? @data : join("", @data);
}

=head2 clockhour

=cut

sub clockhour {
  my $self=shift;
  my $value=&hour($self);
  my @table=();
  my $rows=6;
  my $cols=4;
  foreach my $row (0 .. $rows - 1) {
    CORE::push @table, [map {my $opt={};
                  $opt->{'-bgcolor'}="DEDEDE" if $value == $_;
                  $self->cgi->td($opt, $self->cgi->a({-href=>$self->self_url(hour=>$_)}, $_));
                 } map {sprintf("%02d", $row * $cols + $_)} (0 .. $cols - 1)];
  }
  return $self->frame(Hour => $self->table(@table));
}

=head2 clockminute

=cut

sub clockminute {
  my $self=shift;
  my $value=&minute($self);
  my $rows=6;
  my $cols=10;
  my @table=();
  foreach my $row (0 .. $rows - 1) {
    CORE::push @table, [map {my $opt={};
                  $opt->{'-bgcolor'}="DEDEDE" if $value == $_;
                  $self->cgi->td($opt, $self->cgi->a({-href=>$self->self_url(minute=>$_)}, $_));
                 } map {sprintf("%02d", $row * $cols + $_)} (0 .. $cols - 1)];
  }
  return $self->frame(Minute => $self->table(@table));
}

=head2 popup_menu

Same as CGI->popup_menu except that if the labels element is an ordered array ref [].  The values and labels elements are calculated for you.

  my $obj=$html->popup_menu(-labels=>[qw{1 Foo 2 Bar 3 Baz 4 Buz}]);

  <select name="" >
    <option value="1">Foo</option>
    <option value="2">Bar</option>
    <option value="3">Baz</option>
    <option value="4">Buz</option>
  </select>

=cut

sub popup_menu {
  my $self=shift();
  my %data=@_;
  my $labels=$data{'-labels'};
  if (ref($labels) eq 'ARRAY') { 
    my $i=0;
    my %labels=@$labels;
    my @values=grep {not $i++ % 2} @$labels;
    $data{'-labels'}=\%labels;
    $data{'-values'}=\@values;
  }
  return $self->cgi->popup_menu(%data);
}

=head2 GooleMapLinkPoint

Returns an external link to a Google Maps Page.

  my $output=$html->GooleMapLinkPoint($lat, $lon, $label);

=cut

sub GooleMapLinkPoint {
  my $self=shift();
  my $lat=shift(); $lat+=0;#convert to perl number
  my $lon=shift(); $lon+=0;#convert to perl number
  my $label=shift();
  my $pt=join(",", $lat, $lon);
  $label=" ($label)" if $label;
  $label=$self->cgi->escape($label);
  my $link="";
  $link=$self->cgi->a({-href=>"http://maps.google.com/maps?q=$pt$label",
                       -target=>"_blank"},
                      $self->cgi->img({-src=>"images/mapicon.gif",
                                       -border=>0}))
           unless (0 == $lat and 0 == $lon);
  return $link;
}

=head1 METHODS (PARAMETER SHORTCUTS)

=head2 datetime, dt

=cut

*dt=\&datetime;

sub datetime {
  my $self=shift;
  unless (ref($self->{"datetime"}) eq "DateTime") {
    my $now=DateTime->now->set_time_zone("UTC");
    my $datetime=DateTime->new(
             year   => $self->cgi->param("year")   || $now->year,   #zero is invalid
             month  => $self->cgi->param("month")  || $now->month,  #zero is invalid
             day    => $self->cgi->param("day")    || $now->day,    #zero is invalid
             hour   => $self->cgi->param("hour")   // $now->hour,   #zero is valid
             minute => $self->cgi->param("minute") // $now->minute, #zero is valid
             second => $self->cgi->param("second") // $now->second, #zero is valid
           )->set_time_zone("UTC");
    $self->{'datetime'}=$datetime;
  }
  return $self->{'datetime'};
}

=head2 year

=cut

sub year {
  my $self=shift;
  return $self->datetime->year;
}

=head2 month

=cut

sub month {
  my $self=shift;
  return sprintf("%02d", $self->datetime->month);
}

=head2 day

=cut

sub day {
  my $self=shift;
  return sprintf("%02d", $self->datetime->day);
}

=head2 hour

=cut

sub hour {
  my $self=shift;
  return sprintf("%02d", $self->datetime->hour);
}

=head2 minute

=cut

sub minute {
  my $self=shift;
  return sprintf("%02d", $self->datetime->minute);
}

=head2 second

=cut

sub second {
  my $self=shift;
  return sprintf("%02d", $self->datetime->second);
}

=head2 ymd

Returns the year, month, and day from CGI parameters or the current day if not defined.  Query string format is ?year=2007;month=12;day=31

  my ($y, $m, $d) = $html->ymd();

=cut

sub ymd {
  my $self=shift();
  my @ymd=($self->year, $self->month, $self->day);
  return wantarray ? @ymd : join('/', @ymd);
}

=head2 mdy

Returns the month, day, and year from CGI parameters or the current day if not defined.  Query string format is ?year=2007;month=12;day=31

  my ($m, $d, $y) = $html->mdy();

=cut

sub mdy {
  my $self=shift();
  my @mdy=($self->month, $self->day, $self->year);
  return wantarray ? @mdy : join('/', @mdy);
}

=head2 hms

Returns the hour, minute, second from CGI parameters or the current day if not defined.  Query string format is ?hour=23;minute=45;second=33

  my ($h, $m, $s) = $html->hms();

=cut

sub hms {
  my $self=shift();
  my @hms=($self->hour, $self->minute, $self->second);
  return wantarray ? @hms : join(':', @hms);
}

=head2 function

Returns the "function" parameter from the CGI environment.

=cut

sub function {
  my $self=shift;
  if (@_) {
    my $value=shift;
    if (defined($value)) {
      $self->cgi->param(-name=>'function', -value=>$value);
    } else {
      $self->cgi->delete(-name=>'function');
    }
  }
  my $function=$self->cgi->param(-name=>"function");
  return defined($function) ? $function : "";
}

=head2 trim

Removes leading and trailing white space from list of strings.

  my $string=$html->trim($string);
  my @string=$html->trim(" one ", "\ttwo\n"); #returns ("one","two")

=cut

sub trim {
  my $self=shift;
  my @list=map {s/\s*$//s;s/^\s*//s;$_} map {"$_"} @_;
  if (scalar(@list) == 1) {
    return $list[0];
  } else {
    wantarray ? @list : \@list;
  }
}

=head2 param_trim

Trims and returns the parameters passed returns them.

  $html->param_trim("foo");                                      #trims CGI->param("foo")
  my $param=$html->param_trim("foo") || '';                      #trims and returns CGI->param("foo")
  my ($foo, $bar, $baz)=$html->param_trim("foo", "bar", "baz");  #trims and returns CGI->param("foo"), CGI->param("bar")...

=cut

sub param_trim {
  my $self=shift;
  my @values=();
  foreach my $key (@_) {
    my $value=$self->cgi->param(-name=>$key);
    if (defined $value) {
      if ($value =~ m/^\s*(.*?)\s*$/) {
        $value=$1;
        $self->cgi->param(-name=>$key, -value=>$value);
      }
    }
    CORE::push @values, $value;
  }
  return wantarray ? @values : shift(@values) ;
}

=head1 METHODS (INTERNAL)

=head2 _Content

Sets or returns the HTML content array.  Most implementations should use the push and unshift methods to populate this array.

=cut

sub _Content {
  my $self=shift();
  $self->{'content'}=shift() if @_;
  $self->{'content'}=[] unless ref($self->{'content'}) eq "ARRAY";
  return wantarray ? @{$self->{'content'}} : $self->{'content'};
}


=head2 _Menu

Returns HTML string for left side menu built from INI file

=cut

sub _Menu {
  my $self = shift;
  return('') unless ($self->ini_file and -r $self->ini_file);
  #Loop through all INI Section to pull the menu items
  my @items = (); #isa ({}, {}, ...)
  foreach my $section ($self->ini->Sections) {
     next unless $self->ini->val($section => type    => '') eq 'menu'; #type=menu (required)
     next unless $self->ini->val($section => enabled => 1 ) eq '1';    #enabled=1 (default=1)
     CORE::push @items, {
                         section => $self->ini->val($section => section => 'Section'), #menu section=xxx (default=Section)
                         url     => $self->ini->val($section => url     => $section),  #item url=xxx (default=section name)
                         text    => $self->ini->val($section => text    => $section),  #item text=xxx (default=section name)
                        }; 
  }

  { #Add Account Information Section
    my @list = ();
    CORE::push @list, sprintf("User: %s (%s)", $self->auth->name, $self->auth->user) if ($self->auth->user);
    CORE::push @list, sprintf("Server: %s", $self->hostname);
    CORE::push @items, map {+{section => 'Account Information', url => '', text => $_}} @list; #+{} force to href instead of block
  }

  #Loop through all items to pull unique sections
  my %sections = (); #for collection #isa (section1=>[{}, {}, {}, ], section2=>[{}, ...], ...)
  my @sections = (); #for order      #isa (section1, section2, section3, ...)
  foreach my $item (@items) {
    my $section      = $item->{'section'};
    my $section_aref = $sections{$section};
    unless ($section_aref) {
      $section_aref = $sections{$section} = [];
      CORE::push @sections, $section;
    }
    CORE::push @$section_aref, $item;
  }

  #Loop through all sections to build the html
  my @frames = ();
  foreach my $section (@sections) {
    my @items = map {
                     my $url  = $_->{'url'};
                     my $text = $_->{'text'};
                     $text    = $self->cgi->b($text) if $self->title eq $text;
                     $url ? $self->cgi->a({-class=>"qmenuitem", -href=>$url}, $text) : $text
                    } @{$sections{$section}};
    CORE::push @frames, $self->frame($section, $self->list(@items));
  }
  return join('', @frames);
}

=head2 _Header

HTML short cut for CGI->header.

=cut

sub _Header {
  my $self=shift();
  my $opt={@_, -type=>'text/html', -charset=>'utf-8'};
  $opt->{'-expires'}=$self->expires if defined $self->expires;
  $opt->{'-Refresh'}=$self->refresh if defined $self->refresh;
  return $self->cgi->header($opt);
}

=head1 COPYRIGHT and LICENSE

Copyright (c) 2025 Michael R. Davis

MIT

=head1 SEE ALSO

L<CGI>, L<CGI::Carp>, L<HTML::CalendarMonthSimple>, L<DateTime>, L<URI>, L<Sys::Hostname>

=cut

1;
