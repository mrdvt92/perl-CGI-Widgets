use ExtUtils::MakeMaker;
WriteMakefile(
    NAME          => 'CGI::Widgets',
    VERSION_FROM  => 'lib/CGI/Widgets.pm',
    AUTHOR        => 'Michael R. Davis (mrdvt92)',
    ABSTRACT_FROM => 'lib/CGI/Widgets.pm',
    LICENSE       => 'mit',
    PREREQ_PM     => {
                      'Package::New'              => 0,
                      'Package::Role::ini'        => 0,
                      'CGI'                       => 0,
                      'CGI::Carp'                 => 0,
                      'HTML::CalendarMonthSimple' => 1.26,
                      'DateTime'                  => 0,
                      'URI'                       => 0,
                      'Sys::Hostname'             => 0,
                      'Test::More'                => 0.44, #tests
                      'Test::HTML::Content'       => 0,    #tests
                     },
  'META_MERGE' => {
    'meta-spec' => {
      'version' => 2
    },
    'resources' => {
      'bugtracker' => {
        'web' => 'https://github.com/mrdvt92/perl-CGI-Widgets/issues'
      },
      'homepage' => 'https://github.com/mrdvt92/perl-CGI-Widgets',
      'repository' => {
        'url' => 'git@github.com:mrdvt92/perl-CGI-Widgets.git',
        'web' => 'https://github.com/mrdvt92/perl-CGI-Widgets.git',
        'type' => 'git'
      }
    }
  },
);
