# t/0002_lexer_token.t
use strict;
use warnings;

use Test::More tests => 3;    # last test to print
use lib '../lib';

use_ok 'Lexer::Token';

use Lexer::Tag;

my $token = Lexer::Token->new( tag => Lexer::Tag->AND );

is $token->tag,       Lexer::Tag->AND;
is $token->to_string, "" . Lexer::Tag->AND;
