# t/08_symbols_array.t
use strict;
use warnings;

use Test::More tests => 5;    # last test to print
use lib '../lib';

use_ok 'Symbols::Array';

my $arr = Symbols::Array->new( of => Symbols::Type->Int, size => 10 );

is $arr->tag,    Lexer::Tag->INDEX;
is $arr->width,  40;
is $arr->lexeme, '[]';
is $arr->to_string, '[10]int';
