# t/15_inter_unary.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use_ok 'Inter::Unary';
use Inter::Expr;

my $arith = Inter::Unary->new(
    op    => Lexer::Word->minus,
    expr => Inter::Expr->new(
        op   => Lexer::Num->new( value => 10 ),
        type => Symbols::Type->Int
    ),
);

isa_ok $arith, 'Inter::Unary';

is $arith->to_string, "minus 10";
