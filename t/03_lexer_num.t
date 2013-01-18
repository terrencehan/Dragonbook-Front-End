# t/0003_lexer_num.t
use strict;
use warnings;

use Test::More tests => 3;    # last test to print
use lib '../lib';

use_ok 'Lexer::Num';

my $num = Lexer::Num->new( value => 123 );

is $num->to_string, "123";

use Lexer::Token;

is $num->tag, Lexer::Tag->NUM;
