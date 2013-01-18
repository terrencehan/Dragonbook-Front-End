# t/07_symbols_type.t
use strict;
use warnings;

use Test::More tests => 14;    # last test to print
use lib '../lib';

use_ok 'Symbols::Type';

is Symbols::Type->Int->lexeme,   'int';
is Symbols::Type->Int->width,    4;
is Symbols::Type->Float->lexeme, 'float';
is Symbols::Type->Float->width,  8;
is Symbols::Type->Char->lexeme,  'char';
is Symbols::Type->Char->width,   1;
is Symbols::Type->Bool->lexeme,  'bool';
is Symbols::Type->Bool->width,   1;

use Lexer::Tag;
is Symbols::Type->Char->tag, Lexer::Tag->BASIC;

is Symbols::Type->numeric( Symbols::Type->Float ), 1;
is Symbols::Type->numeric( Symbols::Type->Bool ),  0;

is Symbols::Type->max( Symbols::Type->Float, Symbols::Type->Float ),
  Symbols::Type->Float;

is Symbols::Type->max( Symbols::Type->Bool, Symbols::Type->Float ), undef;

