# t/27_inter_setelem.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use_ok 'Parser::Parser';

my $parser = Parser::Parser->new;

isa_ok $parser, 'Parser::Parser';
