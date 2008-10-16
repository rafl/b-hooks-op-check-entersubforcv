use strict;
use warnings;
use Test::More tests => 3;

sub foo {}

my $i;
BEGIN { $i = 0; }

sub callback { $i++ }

use B::Hooks::OP::Check::EntersubForCV
    \&foo => \&callback,
    \&foo => \&callback,
    \&callback => sub {};

BEGIN { is($i, 0) }

foo();

BEGIN { is($i, 2) }

no B::Hooks::OP::Check::EntersubForCV \&foo;

BEGIN { is($i, 2) }
