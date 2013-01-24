# t/27_inter_setelem.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';
use Data::Dump qw/dump/;

use_ok 'Parser::Parser';

my $parser = Parser::Parser->new;

isa_ok $parser, 'Parser::Parser';

#$parser->run;


$parser->move;
dump $parser->look;
use Lexer::Tag;
$parser->match(Lexer::Tag->ID);
