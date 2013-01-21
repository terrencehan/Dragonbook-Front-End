# t/20_inter_and.t
use strict;
use warnings;

use Test::More tests => 4;
use lib '../lib';

use_ok 'Inter::And';
use Inter::Constant;

my $and = Inter::And->new(
    op    => Lexer::Word->and,
    expr1 => Inter::Constant->False, 
    expr2 => Inter::Constant->True,
);

isa_ok $and, 'Inter::And';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$and->gen;
is $str. "\n", <<END;
\tgoto L1
\tt1 = true
\tgoto L2
L1:\tt1 = false
L2:
END


$and = Inter::And->new(
    op    => Lexer::Word->and,
    expr1 => Inter::Constant->True,
    expr2 => Inter::Constant->False, 
);


open STDOUT, ">", \$str;
$and->gen;
is $str."\n", <<END;
\tgoto L3
\tt2 = true
\tgoto L4
L3:\tt2 = false
L4:
END
