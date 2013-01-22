# t/14_inter_arith.t
use strict;
use warnings;

use Test::More tests => 5;
use lib '../lib';

use_ok 'Inter::Arith';
use Inter::Expr;

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

isa_ok $arith, 'Inter::Arith';

is $arith->to_string, "10 + 11";

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;

my $t = $arith->reduce;
is $str, "\tt1 = 10 + 11\n";
is $t->type, Symbols::Type->Int;
