# t/23_inter_access.t
use strict;
use warnings;

use Test::More tests => 5;
use lib '../lib';

use_ok 'Inter::Access';
use Inter::Expr;
use Inter::Id;
use Inter::Not;
use Inter::Constant;
use Symbols::Array;


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
    type  => Symbols::Type->Bool,
);

isa_ok $access, 'Inter::Access';

is $access->to_string, "arr_name[ 5 ]";

my $str = "";
open my $old_stdout, ">&", \*STDOUT; 
close STDOUT;
open STDOUT, ">", \$str;
$access->reduce;
is $str, "\tt1 = arr_name[ 5 ]\n";

#open STDOUT, ">&", $old_stdout;

my $not = Inter::Not->new(
    op    => Lexer::Token->new(tag => ord '!'), 
    expr1 => $access, 
    expr2 => $access, 
);

open STDOUT, ">", \$str;
$not->gen;

is $str."\n", <<END;
\tt3 = arr_name[ 5 ]
\tif t3 goto L1
\tt2 = true
\tgoto L2
L1:\tt2 = false
L2:
END
