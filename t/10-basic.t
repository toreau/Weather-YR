#!/usr/bin/env perl
#
use 5.006;
use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 1;

use Weather::Yr;

my $yr = Weather::Yr->new(
    lat => 63.590833,
    lon => 10.741389,
);

# Make sure that the API URLs are correct.
is( $yr->location_forecast->url, 'http://api.yr.no/weatherapi/locationforecast/1.9/?lat=63.590833;lon=10.741389;msl=0',              'URL for location forecast is OK.' );
# is( $yr->text_location->url,     'http://api.yr.no/weatherapi/textlocation/1.0/?latitude=63.590833;longitude=10.741389;language=nb', 'URL for text location is OK.'     );

# The End
done_testing;
