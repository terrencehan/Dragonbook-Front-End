# t/09_symbols_env.t
use strict;
use warnings;

use Test::More tests => 5;    # last test to print
use lib '../lib';

use_ok 'Symbols::Env';

my $env = Symbols::Env->new();
