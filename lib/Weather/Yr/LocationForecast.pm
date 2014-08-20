package Weather::YR::LocationForecast;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Base';

use DateTime;
use DateTime::Format::ISO8601;

use Weather::YR::LocationForecast::DataPoint;
use Weather::YR::LocationForecast::Day;

use Weather::YR::Model::Clouds;
use Weather::YR::Model::Dewpoint;
use Weather::YR::Model::Fog;
use Weather::YR::Model::Humidity;
use Weather::YR::Model::Precipitation::Symbol;
use Weather::YR::Model::Precipitation;
use Weather::YR::Model::Pressure;
use Weather::YR::Model::Temperature;
use Weather::YR::Model::WindDirection;
use Weather::YR::Model::WindSpeed;

=head1 NAME

Weather::YR::LocationForecast - Object-oriented interface to Yr.no's "location
forecast" API.

=head1 DESCRIPTION

Don't use this class directly. Instead, access it from the L<Weather::YR> class.

=cut

has 'url'        => ( isa => 'Str',                                                is => 'ro', lazy_build => 1 );
has 'datapoints' => ( isa => 'ArrayRef[Weather::YR::LocationForecast::DataPoint]', is => 'ro', lazy_build => 1 );
has 'days'       => ( isa => 'ArrayRef[Weather::YR::LocationForecast::Day]',       is => 'ro', lazy_build => 1 );

has 'now'        => ( isa => 'Weather::YR::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );
has 'today'      => ( isa => 'Weather::YR::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );
has 'tomorrow'   => ( isa => 'Weather::YR::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );

=head1 METHODS

=head2 url

Returns the URL for Yr.no's location forecast service.

=cut

sub _build_url {
    my $self = shift;

    return 'http://api.yr.no/weatherapi/locationforecast/1.9/?lat=' . $self->lat . ';lon=' . $self->lon . ';msl=' . $self->msl;
}

=head2 datapoints

Returns an array reference of L<Weather::YR::LocationForecast::DataPoint> instances.

=cut

sub _build_datapoints {
    my $self = shift;

    my $xml_ref    = $self->xml_ref;
    my $times      = $xml_ref->{weatherdata}->{product}->{time} || [];
    my $datapoint  = undef;
    my @datapoints = ();

    foreach my $t ( @{$times} ) {

        my $from = $self->date_to_datetime( $t->{from}->{value} );
        my $to   = $self->date_to_datetime( $t->{to  }->{value} );

        if ( $t->{location}->{temperature} ) {
            my $loc = $t->{location};

            if ( defined $datapoint ) {
                push( @datapoints, $datapoint );
                $datapoint = undef;
            }

            $datapoint = Weather::YR::LocationForecast::DataPoint->new(
                from => $from,
                to   => $to,
                lang => $self->lang,
                type => $t->{datatype}->{value},

                temperature => Weather::YR::Model::Temperature->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    celsius => $loc->{temperature}->{value}->{value},
                ),

                wind_direction => Weather::YR::Model::WindDirection->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    degrees => $loc->{windDirection}->{deg}->{value},
                    name    => $loc->{windDirection}->{name}->{value},
                ),

                wind_speed => Weather::YR::Model::WindSpeed->new(
                    from     => $from,
                    to       => $to,
                    lang     => $self->lang,
                    mps      => $loc->{windSpeed}->{mps}->{value},
                    beaufort => $loc->{windSpeed}->{beaufort}->{value},
                    name     => $loc->{windSpeed}->{name}->{value},
                ),

                humidity => Weather::YR::Model::Humidity->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    percent => $loc->{humidity}->{value}->{value},
                ),

                pressure => Weather::YR::Model::Pressure->new(
                    from => $from,
                    to   => $to,
                    lang => $self->lang,
                    hPa  => $loc->{pressure}->{value}->{value},
                ),

                clouds => Weather::YR::Model::Clouds->new(
                    from       => $from,
                    to         => $to,
                    lang       => $self->lang,
                    cloudiness => $loc->{cloudiness}->{percent}->{value},
                    low        => $loc->{lowClouds}->{percent}->{value},
                    medium     => $loc->{mediumClouds}->{percent}->{value},
                    high       => $loc->{highClouds}->{percent}->{value},
                ),

                fog => Weather::YR::Model::Fog->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    percent => $loc->{fog}->{percent}->{value},
                ),

                dewpoint => Weather::YR::Model::Dewpoint->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    celsius => $loc->{dewpointTemperature}->{value}->{value},
                ),
            );
        }
        elsif ( my $p = $t->{location}->{precipitation} ) {
            my $precipitation = Weather::YR::Model::Precipitation->new(
                from   => $from,
                to     => $to,
                lang   => $self->lang,
                value  => $p->{value}->{value},
                min    => $p->{minvalue}->{value},
                max    => $p->{maxvalue}->{value},
                symbol => Weather::YR::Model::Precipitation::Symbol->new(
                    from   => $from,
                    to     => $to,
                    lang   => $self->lang,
                    id     => $t->{location}->{symbol}->{id}->{value},
                    number => $t->{location}->{symbol}->{number}->{value},
                ),
            );

            $datapoint->add_precipitation( $precipitation );
        }
    }

    return \@datapoints;
}

=head2 days

Returns an array reference of L<Weather::YR::LocationForecast::Day> instances.

=cut

sub _build_days {
    my $self = shift;

    my %day_datapoints = ();

    foreach my $datapoint ( @{$self->datapoints} ) {
        push( @{$day_datapoints{$datapoint->{from}->ymd}}, $datapoint );
    }

    my @days = ();

    foreach my $date ( sort keys %day_datapoints ) {
        my $day = Weather::YR::LocationForecast::Day->new(
            date       => DateTime::Format::ISO8601->parse_datetime( $date ),
            datapoints => $day_datapoints{ $date },
        );

        push( @days, $day );
    }

    return \@days;
}

=head2 now

Returns a L<Weather::YR::LocationForecast::Day> instance, representing the
closest forecast in time.

=cut

sub _build_now {
    my $self = shift;

    my $now        = DateTime->now( time_zone => 'UTC' );
    my $closest_dp = undef;

    foreach my $dp ( @{$self->today->datapoints} ) {
        unless ( defined $closest_dp ) {
            $closest_dp = $dp;
            next;
        }

        my $diff_from_now = abs( $dp->from->epoch - $now->epoch );

        if ( $diff_from_now < ( abs($closest_dp->from->epoch - $now->epoch) ) ) {
            $closest_dp = $dp;
        }
    }

    return Weather::YR::LocationForecast::Day->new(
        date       => $closest_dp->from,
        datapoints => [ $closest_dp ],
    );
}

=head2 today

Returns a L<Weather::YR::LocationForecast::Day> instance, representing today's
weather.

=cut

sub _build_today {
    my $self = shift;

    return $self->days->[0];
}

=head2 tomorrow

Returns a L<Weather::YR::LocationForecast::Day> instance, representing
tomorrow's weather.

=cut

sub _build_tomorrow {
    my $self = shift;

    return $self->days->[1];
}

__PACKAGE__->meta->make_immutable;

1;
