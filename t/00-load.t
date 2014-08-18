#!/usr/bin/env perl
#
use 5.006;
use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Weather::Yr' );
}

diag( "Testing Weather::Yr $Weather::Yr::VERSION, Perl $], $^X" );

done_testing;
