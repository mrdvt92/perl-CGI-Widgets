# NAME

CGI::Widgets - HTML website for CGI perl tools.

# SYNOPSIS

    use CGI::Widgets;
    my $html=CGI::Widgets-new;
    print $html->render;

# DESCRIPTION

This package is a wrapper around [CGI](https://metacpan.org/pod/CGI).  It provides a full featured menu environment for CGI scripts.

# CONSTRUCTOR

## new

    my $html = CGI::Widgets->new();

# METHODS (OBJECT)

## content

Returns HTML content.

## content\_minimal

## render

Returns the entire HTML page with cgi header.

    print $html->render;

## push

Pushes arguments on to the end of the content array.

## unshift

Unshifts arguments on to the front of the content array.

## cgi

Returns the CGI object which is constructed on initialization.

## auth

Returns an CGI::Widgets::Auth object.

## title

Sets and returns the page title.

## onload

Sets and returns the JavaScript in the onload event handler.

## script

    $html->script({-src=>"/js/ac.js"});
    $html->script("SomeJavaScriptFunction;");

## focus

Sets and returns the name of the JavaScript object that is to recieved focus on page load.

    $html->focus("mytextbox");

## footer

Sets and returns the HTML footer

## copyright\_owner

## support\_email

## banner

Sets and returns the HTML banner

## banner\_height

Default: 95

## banner\_width

Default: 200

## expires

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

## refresh

    $html->refresh(60); #seconds
    $html->refresh('60; URL=http://www.cpan.org/'); #redirect

# METHODS (HTML SHORTCUTS)

## table

HTML short cut for a formatted table.

    my $table=$html->table([1], [2], [3]);

## tablename

Returns an HTML table with the first row being formated for column names.

    my $output=$html->tablename([qw{Col1 Col2}], [qw{a1 a2}], [qw{b1 b2}]);

## paramsort

This function returns the value in the "sort.id" parameter which is a non-zero integer that can be passed directly into the 
DBIx::Array->sqlarrayarraynamesort function.

    my $sort = $html->paramsort("t1", -1); #where "t1" is an id string for this table and "-1" is the default sort value.

## tablenamesort

    print $html->tablenamesort("id", @data);
    print $html->tablenamesort("id",
            $sdb->sqlarrayarraynamesort(
              $sql, $html->paramsort("id"), @parameters));

## frame

HTML short cut for a table frame.

    my $frame = $html->frame('Title', 'Content');

## form

Returns the start\_form and end\_form tags.

    $html->form(@fields);
    $html->form(\%hash, @fields);
    $html->form({-multipart=>1}, @fields);

## script\_name

Returns script basename which is implemented as 

    return $self->cgi->url(-relative=>1);

## hostname

Returns the hostname of the service running the script.

## list

Returns an unordered list.

## link

HTML shortcut for an anchor from a registered object.

    my $link=$html->link($object);

## a

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

## tile\_group

A wrapper around CGI div to contain and tile group.

    $html->tile_group($html->tile(), $html->tile(), ...);

## tile

Wrapper around div and img tags to create a floating clickable image tile

    $html->tile(
                {image=>"", width=>160, height=>120, href=>"", target=>"_blank", ...}, 
                "Hover Text" #used to set img title (for hover) and alt text
               )

    Note: image, width, and height are stripped and used for the tile and image construction all other properties are sent to the anchor element (e.g., href, id)

## tab\_group

    $html->tab_group(\%opt, \@tabs)
    $html->tab_group(\@tabs)

    $html->tab_group(
      [
        {label=>$label1, content=> $content1},
        {label=>$label2, content=> $content2},
        {label=>$label3, content=> $content3},
      ]
    );

## checkbox

CGI checkbox pass through with checkall property

## checkall

CGI check box with specified checkall group

## self\_url

Return a URL with correct state preserved.

    my $url = $html->self_url;               #returns relative URL with current state
    my $url = $html->self_url(key=>"value"); #returns relative URL with query overridden with key value pairs.
    

Note: CGI->self\_url returns full URLs which is not compatible with an https to http reverse proxy.

## cal

Returns an HTML calendar with links that preserve state.

    print $html->cal;
    print $html->cal(highlight=>[1,2,3,4]);

## clock

## clockhour

## clockminute

## popup\_menu

Same as CGI->popup\_menu except that if the labels element is an ordered array ref \[\].  The values and labels elements are calculated for you.

    my $obj=$html->popup_menu(-labels=>[qw{1 Foo 2 Bar 3 Baz 4 Buz}]);

    <select name="" >
      <option value="1">Foo</option>
      <option value="2">Bar</option>
      <option value="3">Baz</option>
      <option value="4">Buz</option>
    </select>

## GooleMapLinkPoint

Returns an external link to a Google Maps Page.

    my $output=$html->GooleMapLinkPoint($lat, $lon, $label);

# METHODS (PARAMETER SHORTCUTS)

## datetime, dt

## year

## month

## day

## hour

## minute

## second

## ymd

Returns the year, month, and day from CGI parameters or the current day if not defined.  Query string format is ?year=2007;month=12;day=31

    my ($y, $m, $d) = $html->ymd();

## mdy

Returns the month, day, and year from CGI parameters or the current day if not defined.  Query string format is ?year=2007;month=12;day=31

    my ($m, $d, $y) = $html->mdy();

## hms

Returns the hour, minute, second from CGI parameters or the current day if not defined.  Query string format is ?hour=23;minute=45;second=33

    my ($h, $m, $s) = $html->hms();

## function

Returns the "function" parameter from the CGI environment.

## trim

Removes leading and trailing white space from list of strings.

    my $string=$html->trim($string);
    my @string=$html->trim(" one ", "\ttwo\n"); #returns ("one","two")

## param\_trim

Trims and returns the parameters passed returns them.

    $html->param_trim("foo");                                      #trims CGI->param("foo")
    my $param=$html->param_trim("foo") || '';                      #trims and returns CGI->param("foo")
    my ($foo, $bar, $baz)=$html->param_trim("foo", "bar", "baz");  #trims and returns CGI->param("foo"), CGI->param("bar")...

# METHODS (INTERNAL)

## \_Content

Sets or returns the HTML content array.  Most implementations should use the push and unshift methods to populate this array.

## \_Menu

Returns HTML string for left side menu built from INI file

## \_Header

HTML short cut for CGI->header.

# COPYRIGHT and LICENSE

Copyright (c) 2025 Michael R. Davis

MIT

# SEE ALSO

[CGI](https://metacpan.org/pod/CGI), [CGI::Carp](https://metacpan.org/pod/CGI%3A%3ACarp), [HTML::CalendarMonthSimple](https://metacpan.org/pod/HTML%3A%3ACalendarMonthSimple), [DateTime](https://metacpan.org/pod/DateTime), [URI](https://metacpan.org/pod/URI), [Sys::Hostname](https://metacpan.org/pod/Sys%3A%3AHostname)
