package Weather::Yr::LocationForecast::Day;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Day';

has 'temperatures'    => ( isa => 'ArrayRef[Weather::Yr::Model::Temperature]', is => 'ro', lazy_build => 1 );
has 'temperature'     => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );

has 'min_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );
has 'max_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );

has 'precipitations' => ( isa => 'ArrayRef[Weather::Yr::Model::Precipitation]', is => 'ro', lazy_build => 1 );
has 'precipitation'  => ( isa => 'Weather::Yr::Model::Precipitation',           is => 'ro', lazy_build => 1 );

=head1 METHODS

=head2 temperatures

Returns an array reference of all the L<Weather::Yr::Model::Temperature>
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

=head2 temperature

Returns the "most logical" L<Weather::Yr::Model::Temperature> data point for
this day.

This works so that if you are working with "now", it will pick the data point
closes to the current time. If you are working with any other days, including
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

Returns the L<Weather::Yr::Model::Temperature> data point with the lowest
temperature value for this day.

=cut

sub _build_min_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[0];
}

=head2 min_temperature

Returns the L<Weather::Yr::Model::Temperature> data point with the highest
temperature value for this day.

=cut

sub _build_max_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[-1];
}

=head2 precipitations

Returns an array reference of all the L<Weather::Yr::Model::Precipitation>
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

Returns "the most logical" L<Weather::Yr::Model::Precipitation> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closes to the current time. If you are working with any other days, including
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

__PACKAGE__->meta->make_immutable;

1;
