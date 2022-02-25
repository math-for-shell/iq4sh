Name:    iq4sh
%global commit fa89f4fe66048e87e8646f0540cb14a073fbb58d
%global githead %(printf %%.7s %commit)
Version: 1.77.%githead
Release: 0.sero1%{?dist}
Summary: Precision decimal calculator written in shell

License: Unlicense
URL:     https://github.com/math-for-shell/iq4sh
Source0: %URL/archive/%commit/%NAME-%githead.tar.gz

BuildArch: noarch


%description
IQ4sh (Intelligent Quotients for the Shell) is a decimal calculator for 
the shell. It can be used as a one-shot calculator from the command line (CLI),
interactively from your shell session, or included in other shell scripts to
provide precision math functionality inside the script.

The file 'iq' is the main calculator, whihc provides functions for Addition,
Subtraction, Multiplication, Division and Modular Division, plus simple
integer exponents. The file 'iq+' is an extended version which adds 
functions for calculating powers, roots, logs, sine, cosine, tan and more.

Run 'iq -h' or 'iq+ -h'  to see the main help page for either program.


%prep
%autosetup -n %NAME-%commit


%build


%install
install -Dp -t %buildroot%_bindir iq*


%files
%license LICENSE
%doc README.md example1.sh
%_bindir/iq*


%changelog
* Tue Dec 28 2021 Sergey Romanov <romanov@b-tu.de> - 1.68^211227.fa89f4f-0.sero1
- update to the latest snapshot

* Mon Dec 20 2021 Sergey Romanov <romanov@b-tu.de> - 1.64^211219.f530f3f-0.sero1
- update to the latest snapshot

* Sun Nov 14 2021 Sergey Romanov <romanov@b-tu.de> - 1.6180339887^211114.7cf79d7-0.sero1
- update to the latest snapshot
- install an example script

* Sun Nov 07 2021 Sergey Romanov <romanov@b-tu.de> - 1.61803398^211107.84b3aa3-0.sero1
- initial build

# vim: et:

