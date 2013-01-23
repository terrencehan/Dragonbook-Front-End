# t/27_inter_set.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use Inter::Constant;
use Inter::Id;
use Inter::Arith;

use_ok 'Inter::Set';

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

my $set = Inter::Set->new(
    id => Inter::Id->new(
        op => Lexer::Word->new(
            lexeme => "id_name",
            tag    => Lexer::Tag->ID,
        ),
        type   => Symbols::Type->Int,
        offset => 10,
    ),
    #expr => Inter::Constant->new( int => 10 ),
    expr => $arith,
);

isa_ok $set, 'Inter::Set';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;
$set->gen(1, 2); 
is $str, "\tid_name = 10 + 11\n";
