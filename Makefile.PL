use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-OP-Check-EntersubForCV';
all_from 'lib/B/Hooks/OP/Check/EntersubForCV.pm';

requires 'B::Hooks::OP::Check';
build_requires 'B::Hooks::OP::Check';
configure_requires 'ExtUtils::Depends';

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::Check::EntersubForCV', 'B::Hooks::OP::Check');

makemaker_args($pkg->get_makefile_vars);

WriteAll;
