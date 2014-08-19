package Weather::Yr::LocationForecast;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Base';

use DateTime;
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

=head1 NAME

Weather::Yr::LocationForecast - Object-oriented interface to Yr.no's "location
forecast" API.

=head1 DESCRIPTION

Don't use this class directly. Instead, access it from the L<Weather::Yr> class.

=cut

has 'url'        => ( isa => 'Str',                                                is => 'ro', lazy_build => 1 );
has 'datapoints' => ( isa => 'ArrayRef[Weather::Yr::LocationForecast::DataPoint]', is => 'ro', lazy_build => 1 );
has 'days'       => ( isa => 'ArrayRef[Weather::Yr::LocationForecast::Day]',       is => 'ro', lazy_build => 1 );

has 'now'        => ( isa => 'Weather::Yr::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );
has 'today'      => ( isa => 'Weather::Yr::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );
has 'tomorrow'   => ( isa => 'Weather::Yr::LocationForecast::Day',                 is => 'ro', lazy_build => 1 );

=head1 METHODS

=head2 url

Returns the URL for Yr.no's location forecast service.

=cut

sub _build_url {
    my $self = shift;

    return 'http://api.yr.no/weatherapi/locationforecast/1.9/?lat=' . $self->lat . ';lon=' . $self->lon . ';msl=' . $self->msl;
}

=head2 datapoints

Returns an array reference of L<Weather::Yr::LocationForecast::DataPoint> instances.

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

            $datapoint = Weather::Yr::LocationForecast::DataPoint->new(
                from => $from,
                to   => $to,
                lang => $self->lang,
                type => $t->{datatype}->{value},

                temperature => Weather::Yr::Model::Temperature->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    celsius => $loc->{temperature}->{value}->{value},
                ),

                wind_direction => Weather::Yr::Model::WindDirection->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    degrees => $loc->{windDirection}->{deg}->{value},
                    name    => $loc->{windDirection}->{name}->{value},
                ),

                wind_speed => Weather::Yr::Model::WindSpeed->new(
                    from     => $from,
                    to       => $to,
                    lang     => $self->lang,
                    mps      => $loc->{windSpeed}->{mps}->{value},
                    beaufort => $loc->{windSpeed}->{beaufort}->{value},
                    name     => $loc->{windSpeed}->{name}->{value},
                ),

                humidity => Weather::Yr::Model::Humidity->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    percent => $loc->{humidity}->{value}->{value},
                ),

                pressure => Weather::Yr::Model::Pressure->new(
                    from => $from,
                    to   => $to,
                    lang => $self->lang,
                    hPa  => $loc->{pressure}->{value}->{value},
                ),

                clouds => Weather::Yr::Model::Clouds->new(
                    from       => $from,
                    to         => $to,
                    lang       => $self->lang,
                    cloudiness => $loc->{cloudiness}->{percent}->{value},
                    low        => $loc->{lowClouds}->{percent}->{value},
                    medium     => $loc->{mediumClouds}->{percent}->{value},
                    high       => $loc->{highClouds}->{percent}->{value},
                ),

                fog => Weather::Yr::Model::Fog->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    percent => $loc->{fog}->{percent}->{value},
                ),

                dewpoint => Weather::Yr::Model::Dewpoint->new(
                    from    => $from,
                    to      => $to,
                    lang    => $self->lang,
                    celsius => $loc->{dewpointTemperature}->{value}->{value},
                ),
            );
        }
        elsif ( my $p = $t->{location}->{precipitation} ) {
            my $precipitation = Weather::Yr::Model::Precipitation->new(
                from   => $from,
                to     => $to,
                lang   => $self->lang,
                value  => $p->{value}->{value},
                min    => $p->{minvalue}->{value},
                max    => $p->{maxvalue}->{value},
                symbol => Weather::Yr::Model::Precipitation::Symbol->new(
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

Returns an array reference of L<Weather::Yr::LocationForecast::Day> instances.

=cut

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

=head2 now

Returns a L<Weather::Yr::LocationForecast::Day> instance, representing the
closest forecast in time.

=cut

sub _build_now {
    my $self = shift;

    my $datetime_now      = DateTime->now;
    my $closest_datapoint = undef;

    foreach my $dp ( @{$self->today->datapoints} ) {
        unless ( defined $closest_datapoint ) {
            $closest_datapoint = $dp;
            next;
        }

        my $diff_from_now = abs( $dp->from->epoch - $datetime_now->epoch );

        if ( $diff_from_now < ( abs($closest_datapoint->from->epoch - $datetime_now->epoch) ) ) {
            $closest_datapoint = $dp;
        }

    }

    return Weather::Yr::LocationForecast::Day->new(
        date       => $closest_datapoint->from,
        datapoints => [ $closest_datapoint ],
    );
}

=head2 today

Returns a L<Weather::Yr::LocationForecast::Day> instance, representing today's
weather.

=cut

sub _build_today {
    my $self = shift;

    return $self->days->[0];
}

=head2 tomorrow

Returns a L<Weather::Yr::LocationForecast::Day> instance, representing
tomorrow's weather.

=cut

sub _build_tomorrow {
    my $self = shift;

    return $self->days->[1];
}

__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Tore Aursand, C<< toreau@gmail.com >>

=head1 LICENSE AND COPYRIGHT

Copyright 2014, Tore Aursand.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
