# t/22_inter_rel.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use_ok 'Inter::Rel';
use Inter::Constant;

my $rel = Inter::Rel->new(
    op    => Lexer::Word->le,
    expr1 => Inter::Constant->new(int=>1), 
    expr2 => Inter::Constant->new(int=>8) 
);

isa_ok $rel, 'Inter::Rel';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$rel->gen;
is $str. "\n", <<END;
\tiffalse 1 <= 8 goto L1
\tt1 = true
\tgoto L2
L1:\tt1 = false
L2:
END
