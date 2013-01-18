# t/05_lexer_word.t
use strict;
use warnings;

use Test::More tests => 13;    # last test to print
use lib '../lib';

use_ok 'Lexer::Word';

is Lexer::Word->and->lexeme,   "&&";
is Lexer::Word->or->lexeme,    "||";
is Lexer::Word->eq->lexeme,    "==";
is Lexer::Word->ne->lexeme,    "!=";
is Lexer::Word->le->lexeme,    "<=";
is Lexer::Word->ge->lexeme,    ">=";
is Lexer::Word->minus->lexeme, "minus";
is Lexer::Word->temp->lexeme,  "t";
is Lexer::Word->True->lexeme,  "true";
is Lexer::Word->False->lexeme, "false";

my $w = Lexer::Word->new( lexeme => "identifier", tag => Lexer::Tag->ID );

is $w->to_string, "identifier";
is $w->tag,       Lexer::Tag->ID;
