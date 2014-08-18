package Weather::Yr::LocationForecast;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Base';

use DateTime::Format::ISO8601;

use Weather::Yr::LocationForecast::DataPoint;

use Weather::Yr::Model::Temperature;
use Weather::Yr::Model::WindDirection;
use Weather::Yr::Model::WindSpeed;
use Weather::Yr::Model::Humidity;
use Weather::Yr::Model::Pressure;
use Weather::Yr::Model::Clouds;
use Weather::Yr::Model::Fog;
use Weather::Yr::Model::Dewpoint;
use Weather::Yr::Model::Precipitation;
use Weather::Yr::Model::Precipitation::Symbol;

use Weather::Yr::LocationForecast::Day;

has 'url'        => ( isa => 'Str',                                                is => 'ro', lazy_build => 1 );
has 'datapoints' => ( isa => 'ArrayRef[Weather::Yr::LocationForecast::DataPoint]', is => 'ro', lazy_build => 1 );
has 'days'       => ( isa => 'ArrayRef[Weather::Yr::LocationForecast::Day]',       is => 'ro', lazy_build => 1 );

sub _build_url {
    my $self = shift;

    return 'http://api.yr.no/weatherapi/locationforecast/1.9/?lat=' . $self->lat . ';lon=' . $self->lon . ';msl=' . $self->msl;
}

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

            $datapoint = Weather::Yr::LocationForecast::DataPoint->new(
                from => $from,
                to   => $to,
                type => $t->{datatype}->{value},

                temperature => Weather::Yr::Model::Temperature->new(
                    from    => $from,
                    to      => $to,
                    celsius => $loc->{temperature}->{value}->{value},
                ),

                wind_direction => Weather::Yr::Model::WindDirection->new(
                    from    => $from,
                    to      => $to,
                    degrees => $loc->{windDirection}->{deg}->{value},
                    name    => $loc->{windDirection}->{name}->{value},
                ),

                wind_speed => Weather::Yr::Model::WindSpeed->new(
                    from     => $from,
                    to       => $to,
                    mps      => $loc->{windSpeed}->{mps}->{value},
                    beaufort => $loc->{windSpeed}->{beaufort}->{value},
                    name     => $loc->{windSpeed}->{name}->{value},
                ),

                humidity => Weather::Yr::Model::Humidity->new(
                    from    => $from,
                    to      => $to,
                    percent => $loc->{humidity}->{value}->{value},
                ),

                pressure => Weather::Yr::Model::Pressure->new(
                    from => $from,
                    to   => $to,
                    hPa  => $loc->{pressure}->{value}->{value},
                ),

                clouds => Weather::Yr::Model::Clouds->new(
                    from       => $from,
                    to         => $to,
                    cloudiness => $loc->{cloudiness}->{percent}->{value},
                    low        => $loc->{lowClouds}->{percent}->{value},
                    medium     => $loc->{mediumClouds}->{percent}->{value},
                    high       => $loc->{highClouds}->{percent}->{value},
                ),

                fog => Weather::Yr::Model::Fog->new(
                    from    => $from,
                    to      => $to,
                    percent => $loc->{fog}->{percent}->{value},
                ),

                dewpoint => Weather::Yr::Model::Dewpoint->new(
                    from    => $from,
                    to      => $to,
                    celsius => $loc->{dewpointTemperature}->{value}->{value},
                ),
            );
        }
        elsif ( my $p = $t->{location}->{precipitation} ) {
            my $precipitation = Weather::Yr::Model::Precipitation->new(
                from   => $from,
                to     => $to,
                value  => $p->{value}->{value},
                min    => $p->{minvalue}->{value},
                max    => $p->{maxvalue}->{value},
                symbol => Weather::Yr::Model::Precipitation::Symbol->new(
                    from   => $from,
                    to     => $to,
                    id     => $t->{location}->{symbol}->{id}->{value},
                    number => $t->{location}->{symbol}->{number}->{value},
                ),
            );

            $datapoint->add_precipitation( $precipitation );
        }
    }

    return \@datapoints;
}

sub _build_days {
    my $self = shift;

    my %day_datapoints = ();

    foreach my $datapoint ( @{$self->datapoints} ) {
        push( @{$day_datapoints{$datapoint->{from}->ymd}}, $datapoint );
    }

    my @days = ();

    foreach my $date ( sort keys %day_datapoints ) {
        my $day = Weather::Yr::LocationForecast::Day->new(
            date       => DateTime::Format::ISO8601->parse_datetime( $date ),
            datapoints => $day_datapoints{ $date },
        );

        push( @days, $day );
    }

    return \@days;
}

__PACKAGE__->meta->make_immutable;

1;
