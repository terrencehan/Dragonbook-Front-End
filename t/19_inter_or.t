# t/19_inter_or.t
use strict;
use warnings;

use Test::More tests => 4;
use lib '../lib';

use_ok 'Inter::Or';
use Inter::Constant;

my $or = Inter::Or->new(
    op    => Lexer::Word->or,
    expr1 => Inter::Constant->False, 
    expr2 => Inter::Constant->True,
);

isa_ok $or, 'Inter::Or';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$or->gen;
is $str. "\n", <<END;
L3:\tt1 = true
\tgoto L2
L1:\tt1 = false
L2:
END


$or = Inter::Or->new(
    op    => Lexer::Word->or,
    expr1 => Inter::Constant->True,
    expr2 => Inter::Constant->False, 
);


open STDOUT, ">", \$str;
$or->gen;
is $str."\n", <<END;
\tgoto L6
\tgoto L4
L6:\tt2 = true
\tgoto L5
L4:\tt2 = false
L5:
END
