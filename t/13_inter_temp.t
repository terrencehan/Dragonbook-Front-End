# t/09_inter_temp.t
use strict;
use warnings;

use Test::More tests => 5;
use lib '../lib';

use_ok 'Inter::Temp';

is Inter::Temp->count, 0;
my $t = Inter::Temp->new;
is Inter::Temp->count, 1;
is $t->number, 1;
is $t->to_string, "t1";

