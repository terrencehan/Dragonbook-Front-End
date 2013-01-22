# t/23_inter_access.t
use strict;
use warnings;

use Test::More tests => 3;
use lib '../lib';

use_ok 'Inter::Access';
use Inter::Expr;

#my $access = Inter::Access->new(
    #array=> Inter::Id->new(), 
    #type => Symbols::Type->Int, 
    #offset=>10, 
#);

#isa_ok $access, 'Inter::Access';

#is $access->to_string, "10 && 11";
