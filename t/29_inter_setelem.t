# t/27_inter_setelem.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use Inter::Constant;
use Inter::Id;
use Inter::Arith;
use Inter::Access;
use Symbols::Array;

use_ok 'Inter::SetElem';

my $access = Inter::Access->new(
    array => Inter::Id->new(
        op => Lexer::Word->new(
            lexeme => "arr_name",
            tag    => Lexer::Tag->ID,
        ),
        type => Symbols::Array->new(
            of   => Symbols::Type->Int,
            size => 10,                   #size of array
        ),
        offset => 10,
    ),
    index => Inter::Constant->new(int=>5),
    type  => Symbols::Type->Int,
);

my $arith = Inter::Arith->new(
    op    => Lexer::Token->new(tag=> ord "+"),
    expr1 => Inter::Expr->new(
        op   => Lexer::Num->new( value => 10 ),
        type => Symbols::Type->Int
    ),
    expr2 => Inter::Expr->new(
        op   => Lexer::Num->new( value => 11 ),
        type => Symbols::Type->Int
    ),
);

my $setelem = Inter::SetElem->new(
    access =>$access,
    expr => $arith,
);

isa_ok $setelem, 'Inter::SetElem';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$setelem->gen(1, 2); 
is $str, <<END;
\tt1 = 10 + 11
\tarr_name [ 5 ] = t1
END
