use strict;
use warnings;

package B::Hooks::OP::Check::EntersubForCV;

use parent qw/DynaLoader/;
use B::Hooks::OP::Check;
use Scalar::Util qw/refaddr/;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

my %CALLBACKS;

sub import {
    my $class = shift;

    die 'odd number of arguments'
        unless @_ % 2 == 0;

    while (@_) {
        my ($cv, $cb) = (shift, shift);
        $CALLBACKS{ refaddr $cv } = register($cv, $cb);
    }

    return;
}

sub unimport {
    my $class = shift;

    unregister($_) for delete @CALLBACKS{ map { refaddr $_ } @_ };
    return;
}

1;
