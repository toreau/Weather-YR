package Weather::YR::LocationForecast::Day;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Day';

# Temperature
has 'temperatures'    => ( isa => 'ArrayRef[Weather::YR::Model::Temperature]', is => 'ro', lazy_build => 1 );
has 'temperature'     => ( isa => 'Weather::YR::Model::Temperature', is => 'ro', lazy_build => 1 );
has 'min_temperature' => ( isa => 'Weather::YR::Model::Temperature', is => 'ro', lazy_build => 1 );
has 'max_temperature' => ( isa => 'Weather::YR::Model::Temperature', is => 'ro', lazy_build => 1 );

# Precipitation
has 'precipitations' => ( isa => 'ArrayRef[Weather::YR::Model::Precipitation]', is => 'ro', lazy_build => 1 );
has 'precipitation'  => ( isa => 'Weather::YR::Model::Precipitation', is => 'ro', lazy_build => 1 );

# Wind direction
has 'wind_directions' => ( isa => 'ArrayRef[Weather::YR::Model::WindDirection]', is => 'ro', lazy_build => 1 );
has 'wind_direction'  => ( isa => 'Weather::YR::Model::WindDirection', is => 'ro', lazy_build => 1 );

# Wind speed
has 'wind_speeds' => ( isa => 'ArrayRef[Weather::YR::Model::WindSpeed]', is => 'ro', lazy_build => 1 );
has 'wind_speed'  => ( isa => 'Weather::YR::Model::WindSpeed', is => 'ro', lazy_build => 1 );
has 'max_wind_speed'  => ( isa => 'Weather::YR::Model::WindSpeed', is => 'ro', lazy_build => 1 );
has 'min_wind_speed'  => ( isa => 'Weather::YR::Model::WindSpeed', is => 'ro', lazy_build => 1 );

# Humidity
has 'humidities' => ( isa => 'ArrayRef[Weather::YR::Model::Humidity]', is => 'ro', lazy_build => 1 );
has 'humidity' => ( isa => 'Weather::YR::Model::Humidity', is => 'ro', lazy_build => 1 );
has 'max_humidity' => ( isa => 'Weather::YR::Model::Humidity', is => 'ro', lazy_build => 1 );
has 'min_humidity' => ( isa => 'Weather::YR::Model::Humidity', is => 'ro', lazy_build => 1 );

=head1 METHODS

=cut

sub _ok_hour {
    my $self = shift;
    my $hour = shift;

    if ( defined $hour && ($hour >= 12 && $hour <= 15) ) {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 temperatures

Returns an array reference of all the L<Weather::YR::Model::Temperature>
data points for this day.

=cut

sub _build_temperatures {
    my $self = shift;

    return [ map { $_->temperature } @{$self->datapoints} ];
}

sub _asc_sorted_temperatures {
    my $self = shift;

    return [ sort {
        $a->celsius <=> $b->celsius
    } @{ $self->temperatures } ];
}

=head2 temperature

Returns the "most logical" L<Weather::YR::Model::Temperature> data point for
this day.

This works so that if you are working with "now", it will pick the data point
closest to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_temperature {
    my $self = shift;

    foreach ( @{$self->temperatures} ) {
        if ( $self->_ok_hour($_->from->hour) ) {
            return $_;
        }
    }

    return $self->temperatures->[0];
}

=head2 min_temperature

Returns the L<Weather::YR::Model::Temperature> data point with the lowest
temperature value for this day.

=cut

sub _build_min_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[0];
}

=head2 min_temperature

Returns the L<Weather::YR::Model::Temperature> data point with the highest
temperature value for this day.

=cut

sub _build_max_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[-1];
}

=head2 precipitations

Returns an array reference of all the L<Weather::YR::Model::Precipitation>
data points for this day.

=cut

sub _build_precipitations {
    my $self = shift;

    my @precips = ();

    foreach ( @{$self->datapoints} ) {
        foreach ( @{$_->precipitations} ) {
            if ( $_->from->ymd eq $self->date->ymd ) {
                push( @precips, $_ );
            }
        }
    }

    return \@precips;
}

=head2 precipitation

Returns "the most logical" L<Weather::YR::Model::Precipitation> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closest to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_precipitation {
    my $self = shift;

    foreach ( @{$self->precipitations} ) {
        if ( $self->_ok_hour($_->from->hour) ) {
            return $_;
        }
    }

    return $self->precipitations->[0];
}

=head2 wind_directions

Returns an array reference of L<Weather::YR::Model::WindDirection> data points
for this day.

=cut

sub _build_wind_directions {
    my $self = shift;

    return [ map { $_->wind_direction } @{$self->datapoints} ];
}

=head2 wind_direction

Returns "the most logical" L<Weather::YR::Model::WindDirection> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closest to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_wind_direction {
    my $self = shift;

    foreach ( @{$self->wind_directions} ) {
        if ( $self->_ok_hour($_->from->hour) ) {
            return $_;
        }
    }

    return $self->wind_directions->[0];
}

=head2 wind_speeds

Returns an array reference of L<Weather::YR::Model::WindSpeed> data points
for this day.

=cut

sub _build_wind_speeds {
    my $self = shift;

    return [ map { $_->wind_speed } @{$self->datapoints} ];
}

sub _asc_sorted_wind_speeds {
    my $self = shift;

    return [ sort {
        $a->mps <=> $b->mps
    } @{ $self->wind_speeds } ];
}

=head2 wind_speed

Returns "the most logical" L<Weather::YR::Model::WindSpeed> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closest to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_wind_speed {
    my $self = shift;

    foreach ( @{$self->wind_speeds} ) {
        if ( $self->_ok_hour($_->from->hour) ) {
            return $_;
        }
    }

    return $self->wind_speed->[0];
}

=head2 min_wind_speed

Returns the L<Weather::YR::Model::WindSpeed> data point with the lowest
wind speed value for this day.

=cut

sub _build_min_wind_speed {
    my $self = shift;

    return $self->_asc_sorted_wind_speeds->[0];
}

=head2 max_wind_speed

Returns the L<Weather::YR::Model::WindSpeed> data point with the highest
wind speed value for this day.

=cut

sub _build_max_wind_speed {
    my $self = shift;

    return $self->_asc_sorted_wind_speeds->[-1];
}

=head2 humidities

Returns an array reference of L<Weather::YR::Model::WindSpeed> data points
for this day.

=cut

sub _build_humidities {
    my $self = shift;

    return [ map { $_->humidity } @{$self->datapoints} ];
}

sub _asc_sorted_humidities {
    my $self = shift;

    return [ sort {
        $a->percent <=> $b->percent
    } @{ $self->humidities } ];
}

=head2 humidity

Returns "the most logical" L<Weather::YR::Model::Humidity> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closest to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_humidity {
    my $self = shift;

    foreach ( @{$self->humidities} ) {
        if ( $self->_ok_hour($_->from->hour) ) {
            return $_;
        }
    }

    return $self->humidities->[0];
}

=head2 min_humidity

Returns the L<Weather::YR::Model::Humidity> data point with the lowest
humidity value for this day.

=cut

sub _build_min_humidity {
    my $self = shift;

    return $self->_asc_sorted_humidities->[0];
}

=head2 max_humidity

Returns the L<Weather::YR::Model::Humidity> data point with the highest
humidity value for this day.

=cut

sub _build_max_humidity {
    my $self = shift;

    return $self->_asc_sorted_humidities->[-1];
}

__PACKAGE__->meta->make_immutable;

1;
