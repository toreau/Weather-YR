#!/usr/bin/env perl
#
use 5.006;
use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 2;

use DateTime::TimeZone;
use File::Slurp;
use FindBin;

use Weather::YR;

my $xml = File::Slurp::read_file( $FindBin::Bin . '/data/locationForecast.xml' );

my $yr = Weather::YR->new(
    xml => $xml,
    tz  => DateTime::TimeZone->new( name => 'Europe/Oslo' ),
);

my $now      = DateTime->new( year => 2014, month => 8, day => 15, hour => 8, minute => 30, second => 0 );
my $forecast = $yr->location_forecast;

is( scalar(@{$forecast->datapoints}), 83, 'Number of data points is OK.' );
is( $forecast->today->datapoints->[0]->from, '2014-08-15T11:00:00', 'From-date for "today" is OK.' );

# The End
done_testing;
