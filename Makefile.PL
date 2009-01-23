use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-OP-Check-EntersubForCV';
all_from 'lib/B/Hooks/OP/Check/EntersubForCV.pm';

requires 'parent';
requires 'Scalar::Util';
requires 'B::Hooks::OP::Check' => '0.11';
build_requires 'B::Hooks::OP::Check' => '0.11';
configure_requires 'ExtUtils::Depends';

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::Check::EntersubForCV', 'B::Hooks::OP::Check', 'B::Utils');
$pkg->install('hook_op_check_entersubforcv.h');
$pkg->add_xs('EntersubForCV.xs');
$pkg->add_pm('lib/B/Hooks/OP/Check/EntersubForCV.pm' => '$(INST_LIB)/B/Hooks/OP/Check/EntersubForCV.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args(
    $pkg->get_makefile_vars,
    dist => { PREOP => 'pod2text lib/B/Hooks/OP/Check/EntersubForCV.pm > README' },
);

extra_tests;

WriteAll;
