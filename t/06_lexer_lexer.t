# t/06_lexer_lexer.t
use strict;
use warnings;

use Test::More tests => 22;    # last test to print
use lib '../lib';

use_ok 'Lexer::Lexer';

my $str = <<STR;
123
id
if
else
while
do
break\n
+
=
STR

is Lexer::Lexer->line, 1;

close STDIN;
open STDIN, "<", \$str;

my $lexer = Lexer::Lexer->new;
my ($word, $tag);

$word = $lexer->scan;
is $word->tag,   Lexer::Tag->NUM;
is $word->value, "123";

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->ID;
is $word->lexeme, "id";

is Lexer::Lexer->line, 2;

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->IF;
is $word->lexeme, "if";

is Lexer::Lexer->line, 3;

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->ELSE;
is $word->lexeme, "else";

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->WHILE;
is $word->lexeme, "while";

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->DO;
is $word->lexeme, "do";

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->BREAK;
is $word->lexeme, "break";

$word = $lexer->scan;
is $word->tag,    43;
is $word->to_string, "+";

$word = $lexer->scan;
is $word->tag,    61;
is $word->to_string, "=";
