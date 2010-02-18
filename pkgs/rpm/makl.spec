Summary: GNU make templates for building C/C++ projects.
Name: makl
Version: 1.8.1
Release: 1
License: BSD
Group: Development/Tools
Source: http://koanlogic.com/makl/download/makl-1.8.1.tar.gz
Patch: makl-buildroot-symlink.patch
BuildRoot: /var/tmp/%{name}-buildroot
BuildArch: noarch

%description
MaKL is a simple and light framework for building multi-platform C/C++
projects, purely based on the Bourne Shell and GNU Make.  It provides a set
of GNU make templates to ease the creation and maintenance of Makefile's, and
a rich Bourne shell API to create configure scripts.
It is ideal for embedded systems due to its cross-compilation, multiplatform
toolchaining mechanisms, and minimal external dependencies.

%prep
%setup -q
%patch -p1 -b .buildroot

%build
sh configure.sh --prefix=%{buildroot}/usr

%install
make install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc ChangeLog README LICENSE
/usr/bin
/usr/share

%changelog
* Wed Feb 17 2010 tho <tho@koanlogic.com> 
- Initial RPM-ization
