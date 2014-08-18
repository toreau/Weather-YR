package Weather::Yr::LocationForecast::DataPoint;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::DataPoint';

has 'temperature'    => ( isa => 'Weather::Yr::Model::Temperature',   is => 'rw', required => 1 );
has 'wind_direction' => ( isa => 'Weather::Yr::Model::WindDirection', is => 'rw', required => 1 );
has 'wind_speed'     => ( isa => 'Weather::Yr::Model::WindSpeed',     is => 'rw', required => 1 );
has 'humidity'       => ( isa => 'Weather::Yr::Model::Humidity',      is => 'rw', required => 1 );
has 'pressure'       => ( isa => 'Weather::Yr::Model::Pressure',      is => 'rw', required => 1 );
has 'clouds'         => ( isa => 'Weather::Yr::Model::Clouds',        is => 'rw', required => 1 );

has 'precipitations' => ( isa => 'ArrayRef[Weather::Yr::Model::Precipitation]', is => 'rw', required => 0, default => sub { [] } );

sub add_precipitation {
    my $self = shift;
    my $p    = shift;

    push( @{$self->precipitations}, $p );
}

__PACKAGE__->meta->make_immutable;

1;
