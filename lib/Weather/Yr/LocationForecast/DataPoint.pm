package Weather::YR::LocationForecast::DataPoint;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::DataPoint';

has 'temperature'             => ( isa => 'Weather::YR::Model::Temperature',              is => 'ro', required => 1 );
has 'wind_direction'          => ( isa => 'Weather::YR::Model::WindDirection',            is => 'ro', required => 1 );
has 'wind_speed'              => ( isa => 'Weather::YR::Model::WindSpeed',                is => 'ro', required => 1 );
has 'humidity'                => ( isa => 'Weather::YR::Model::Humidity',                 is => 'ro', required => 1 );
has 'pressure'                => ( isa => 'Weather::YR::Model::Pressure',                 is => 'ro', required => 1 );
has 'clouds'                  => ( isa => 'Weather::YR::Model::Clouds',                   is => 'ro', required => 1 );
has 'temperature_probability' => ( isa => 'Weather::YR::Model::Probability::Temperature', is => 'ro', required => 1 );
has 'wind_probability'        => ( isa => 'Weather::YR::Model::Probability::Wind',        is => 'ro', required => 1 );

has 'precipitations' => ( isa => 'ArrayRef[Weather::YR::Model::Precipitation]', is => 'rw', required => 0, default => sub { [] } );

sub add_precipitation {
    my $self = shift;
    my $p    = shift;

    push( @{$self->precipitations}, $p );
}

__PACKAGE__->meta->make_immutable;

1;
