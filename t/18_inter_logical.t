# t/18_inter_logical.t
use strict;
use warnings;

use Test::More tests => 2;
use lib '../lib';

use_ok 'Inter::Logical';
use Inter::Constant;

my $logic = Inter::Logical->new(
    op    => Lexer::Word->and,
    expr1 => Inter::Constant->True,
    expr2 => Inter::Constant->False
);

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$logic->gen;
is $str. "\n", <<END;
\tiffalse true && false goto L1
\tt1 = true
\tgoto L2
L1:\tt1 = false
L2:
END
