# t/09_symbols_env.t
use strict;
use warnings;

use Test::More tests => 4; 
use lib '../lib';

use_ok 'Inter::Node';

is Inter::Node->labels, 0;

my $node = Inter::Node->new;

is $node->lexline, 1;

$node->newlabel;

is Inter::Node->labels, 1;

