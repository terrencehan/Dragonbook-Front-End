# t/04_lexer_real.t
use strict;
use warnings;

use Test::More tests => 3;    # last test to print
use lib '../lib';

use_ok 'Lexer::Real';

my $num = Lexer::Real->new( value => 123.1 );

is $num->to_string, "123.1";

use Lexer::Token;

is $num->tag, Lexer::Tag->REAL;
