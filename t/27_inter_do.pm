# t/27_inter_do.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use Inter::Constant;
use Inter::Set;
use Inter::Arith;
use Inter::Id;
use Inter::Rel;

use_ok 'Inter::Do';

my $rel = Inter::Rel->new(
    op    => Lexer::Word->le,
    expr1 => Inter::Constant->new(int=>1), 
    expr2 => Inter::Constant->new(int=>8) 
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

my $set = Inter::Set->new(
    id => Inter::Id->new(
        op => Lexer::Word->new(
            lexeme => "id_name",
            tag    => Lexer::Tag->ID,
        ),
        type   => Symbols::Type->Int,
        offset => 10,
    ),
    expr => $arith,
);

my $do = Inter::Do->new(
    expr => $rel,
    stmt => $set,
);

isa_ok $do, 'Inter::Do';

my $str = "";
close STDOUT;
open STDOUT, ">", \$str;

my $begin = $do->newlabel;
my $after = $do->newlabel;
$do->emitlabel($begin);
$do->gen($begin, $after);
$do->emitlabel($after);

is $str."\n", <<END;
L1:\tid_name = 10 + 11
L3:\tif 1 <= 8 goto L1
L2:
END
