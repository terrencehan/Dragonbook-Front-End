# t/21_inter_not.t
use strict;
use warnings;

use Test::More tests => 4;
use lib '../lib';

use_ok 'Inter::Not';
use Inter::Constant;

my $not = Inter::Not->new(
    op    => Lexer::Word->and, #bug where is not?
    expr1 => Inter::Constant->True, 
    expr2 => Inter::Constant->True,
);

isa_ok $not, 'Inter::Not';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$not->gen;
is $str. "\n", <<END;
\tgoto L1
\tt1 = true
\tgoto L2
L1:\tt1 = false
L2:
END


$not = Inter::Not->new(
    op    => Lexer::Word->and, #bug, as above
    expr1 => Inter::Constant->False,
    expr2 => Inter::Constant->False, 
);


open STDOUT, ">", \$str;
$not->gen;
is $str."\n", <<END;
\tt2 = true
\tgoto L4
L3:\tt2 = false
L4:
END
