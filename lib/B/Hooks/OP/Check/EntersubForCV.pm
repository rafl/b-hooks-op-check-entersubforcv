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

__END__

=head1 NAME

B::Hooks::OP::Check::EntersubForCV - Invoke callbacks on construction of entersub OPs for certain CVs

=head1 SYNOPSIS

=head2 From Perl

    sub foo {}

    use B::Hooks::OP::Check::EntersubForCV
        \&foo => sub { warn "entersub for foo() being compiled" };

    foo(); # callback is invoked when this like is compiled

    no B::Hooks::OP::Check::EntersubForCV \&foo;

    foo(); # callback isn't invoked

=head2 From C/XS

    #include "hooks_op_check_entersubforcv.h"

    STATIC OP *
    my_callback (pTHX_ OP *op, CV *cv, void *user_data) {
        /* ... */
        return op;
    }

    hook_op_check_id id;

    /* register callback */
    id = hook_op_check_entersubforcv (cv, my_callback, NULL);

    /* unregister */
    hook_op_check_entersubforcv_remove (id);

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008 Florian Ragwitz

This module is free software.

You may distribute this code under the same terms as Perl itself.

=cut
