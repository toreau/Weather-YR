package Weather::Yr::LocationForecast::Day;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Day';

has 'temperatures'    => ( isa => 'ArrayRef[Weather::Yr::Model::Temperature]', is => 'ro', lazy_build => 1 );
has 'min_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );
has 'max_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );

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

sub _build_min_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[0];
}

sub _build_max_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[-1];
}

__PACKAGE__->meta->make_immutable;

1;
