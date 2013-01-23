# t/25_inter_else.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use Inter::Constant;
use Inter::Set;
use Inter::Arith;
use Inter::Id;
use Inter::Rel;

use_ok 'Inter::Else';

my $rel = Inter::Rel->new(
    op    => Lexer::Word->le,
    expr1 => Inter::Constant->new(int=>1), 
    expr2 => Inter::Constant->new(int=>8) 
);

my $arith1 = Inter::Arith->new(
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

my $arith2 = Inter::Arith->new(
    op    => Lexer::Token->new(tag=> ord "+"),
    expr1 => Inter::Expr->new(
        op   => Lexer::Num->new( value => 12 ),
        type => Symbols::Type->Int
    ),
    expr2 => Inter::Expr->new(
        op   => Lexer::Num->new( value => 13 ),
        type => Symbols::Type->Int
    ),
);

my $set1 = Inter::Set->new(
    id => Inter::Id->new(
        op => Lexer::Word->new(
            lexeme => "id_name",
            tag    => Lexer::Tag->ID,
        ),
        type   => Symbols::Type->Int,
        offset => 10,
    ),
    expr => $arith1,
);

my $set2 = Inter::Set->new(
    id => Inter::Id->new(
        op => Lexer::Word->new(
            lexeme => "id_name",
            tag    => Lexer::Tag->ID,
        ),
        type   => Symbols::Type->Int,
        offset => 11,
    ),
    expr => $arith2,
);

my $else = Inter::Else->new(
    expr => $rel,
    stmt1 => $set1,
    stmt2 => $set2,
);

isa_ok $else, 'Inter::Else';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;

my $begin = $else->newlabel;
my $after = $else->newlabel;
$else->emitlabel($begin);
$else->gen($begin, $after);
$else->emitlabel($after);

is $str."\n", <<END;
L1:\tiffalse 1 <= 8 goto L4
L3:\tid_name = 10 + 11
\tgoto L2
L4:\tid_name = 12 + 13
L2:
END
