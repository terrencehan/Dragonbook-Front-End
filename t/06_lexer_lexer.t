# t/06_lexer_lexer.t
use strict;
use warnings;

use Test::More tests => 15;    # last test to print
use lib '../lib';

use_ok 'Lexer::Lexer';

my $str = <<STR;
123
id
if
else
while
do
break
STR

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

$word = $lexer->scan;
is $word->tag,    Lexer::Tag->IF;
is $word->lexeme, "if";

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
