Name:           perl-CGI-Widgets
Version:        2.01
Release:        1%{?dist}
Summary:        HTML website for perl tools
License:        MIT
Group:          Development/Libraries
URL:            http://linux.davisnetworks.com/
Source0:        http://linux.davisnetworks.com/CGI-Widgets-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch
BuildRequires:  perl(ExtUtils::MakeMaker)
BuildRequires:  perl(Test::More) >= 0.44
BuildRequires:  perl(CGI) >= 2.47
BuildRequires:  perl(Class::MethodMaker)
BuildRequires:  perl(DateTime)
BuildRequires:  perl(HTML::CalendarMonthSimple) >= 1.26
BuildRequires:  perl(Path::Class)
BuildRequires:  perl(URI)
BuildRequires:  perl(Package::New)
BuildRequires:  perl(Package::Role::ini)
BuildRequires:  perl(Test::HTML::Content)
Requires:       perl(CGI) >= 2.47
Requires:       perl(Class::MethodMaker)
Requires:       perl(DateTime)
Requires:       perl(HTML::CalendarMonthSimple) >= 1.26
Requires:       perl(URI)
Requires:       perl(Package::New)
Requires:       perl(Package::Role::ini)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description
This package is a wrapper around CGI. It provides a full featured menu
environment for CGI scripts.

%prep
%setup -q -n CGI-Widgets-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

%{_fixperms} $RPM_BUILD_ROOT/*

mkdir -p           $RPM_BUILD_ROOT/%{_sysconfdir}
cp cgi-widgets.ini $RPM_BUILD_ROOT/%{_sysconfdir}/

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc Changes LICENSE README.md
%{perl_vendorlib}/*
%{_mandir}/man3/*
%config(noreplace) %attr(0644,root,root) %{_sysconfdir}/cgi-widgets.ini

%changelog
