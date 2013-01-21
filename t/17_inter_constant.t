# t/17_inter_constant.t
use strict;
use warnings;

use Test::More tests => 6; 
use lib '../lib';

use_ok 'Inter::Constant';

my $const = Inter::Constant->new( int => 2 );
isa_ok $const, 'Inter::Constant';

is Inter::Constant->False->op->to_string, 'false';
is Inter::Constant->True->op->to_string,  'true';

is $const->op->to_string, "2";
is $const->type, Symbols::Type->Int;
