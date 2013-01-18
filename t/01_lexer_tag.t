use strict;
use warnings;

use Test::More tests => 21;    # last test to print
use lib '../lib';

use_ok 'Lexer::Tag';

is Lexer::Tag->AND,   256;
is Lexer::Tag->BASIC, 257;
is Lexer::Tag->BREAK, 258;
is Lexer::Tag->DO,    259;
is Lexer::Tag->ELSE,  260;
is Lexer::Tag->EQ,    261;
is Lexer::Tag->FALSE, 262;
is Lexer::Tag->GE,    263;
is Lexer::Tag->ID,    264;
is Lexer::Tag->IF,    265;
is Lexer::Tag->INDEX, 266;
is Lexer::Tag->LE,    267;
is Lexer::Tag->MINUS, 268;
is Lexer::Tag->NE,    269;
is Lexer::Tag->NUM,   270;
is Lexer::Tag->OR,    271;
is Lexer::Tag->REAL,  272;
is Lexer::Tag->TEMP,  273;
is Lexer::Tag->TRUE,  274;
is Lexer::Tag->WHILE, 275;
