#!/usr/bin/env perl
#
use 5.006;
use strict;
use warnings FATAL => 'all';

use Test::More;

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

is( $forecast->today->min_temperature->celsius, '10.7', 'Min. temperature is OK.' );
is( $forecast->today->max_temperature->celsius, '15.4', 'Max. temperature is OK.' );

is( $forecast->today->wind_direction->name, 'NW', 'Wind direction is OK.' );
is( $forecast->today->wind_direction->degrees, '297.0', 'Wind direction in degrees is OK.' );

is( $forecast->today->wind_speed->mps, '2.0', 'Wind speed is OK.' );
is( $forecast->today->min_wind_speed->mps, '2.0', 'Max. wind speed is OK.' );
is( $forecast->today->max_wind_speed->mps, '4.1', 'Max. wind speed is OK.' );

is( $forecast->today->humidity->percent, '71.3', 'Humidity is OK.' );
is( $forecast->today->min_humidity->percent, '53.7', 'Min. humidity is OK.' );
is( $forecast->today->max_humidity->percent, '83.2', 'Min. humidity is OK.' );

# The End
done_testing;
