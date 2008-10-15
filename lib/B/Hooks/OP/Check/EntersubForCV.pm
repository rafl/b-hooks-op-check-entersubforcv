use strict;
use warnings;

package B::Hooks::OP::Check::EntersubForCV;

use parent qw/DynaLoader/;
use B::Hooks::OP::Check;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;
