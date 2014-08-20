package Weather::YR::LocationForecast::DataPoint;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::DataPoint';

has 'temperature'    => ( isa => 'Weather::YR::Model::Temperature',   is => 'rw', required => 1 );
has 'wind_direction' => ( isa => 'Weather::YR::Model::WindDirection', is => 'rw', required => 1 );
has 'wind_speed'     => ( isa => 'Weather::YR::Model::WindSpeed',     is => 'rw', required => 1 );
has 'humidity'       => ( isa => 'Weather::YR::Model::Humidity',      is => 'rw', required => 1 );
has 'pressure'       => ( isa => 'Weather::YR::Model::Pressure',      is => 'rw', required => 1 );
has 'clouds'         => ( isa => 'Weather::YR::Model::Clouds',        is => 'rw', required => 1 );

has 'precipitations' => ( isa => 'ArrayRef[Weather::YR::Model::Precipitation]', is => 'rw', required => 0, default => sub { [] } );

sub add_precipitation {
    my $self = shift;
    my $p    = shift;

    push( @{$self->precipitations}, $p );
}

__PACKAGE__->meta->make_immutable;

1;
