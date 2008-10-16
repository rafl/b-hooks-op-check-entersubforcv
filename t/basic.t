use strict;
use warnings;
use Test::More tests => 18;

BEGIN { use_ok('B::Hooks::OP::Check::EntersubForCV') }

sub foo { 'affe'  }
sub bar { 'birne' }

my ($i, $cv);
BEGIN {
    $i = 0;
    $cv = \&foo;
}

sub entersub_cb {
    my ($code) = @_;
    $i++;
    is($code->(), 'affe', 'got the right coderef');
}

foo();

my @id;

BEGIN {
    is($i, 0, 'no callback yet');

    push @id, B::Hooks::OP::Check::EntersubForCV::register($cv, \&entersub_cb);
    is($i, 0, 'no callback after registration');
}

foo();
bar();

BEGIN {
    is($i, 1, 'simple callback');
}

foo();
bar();
foo();

BEGIN {
    is($i, 3, 'multiple callbacks');

    push @id, B::Hooks::OP::Check::EntersubForCV::register($cv, \&entersub_cb);
    is($i, 3, 'no callback after multiple registrations');
}

foo();
bar();
foo();

BEGIN {
    is($i, 7, 'multiple callbacks for multiple entersubs');

    B::Hooks::OP::Check::EntersubForCV::unregister(pop @id);
}

foo();
bar();
foo();

BEGIN {
    is($i, 9, 'deregistration');

    B::Hooks::OP::Check::EntersubForCV::unregister(pop @id);
}

foo();
bar();
foo();

BEGIN {
    is($i, 9, 'no callbacks after removing all registers');
}
