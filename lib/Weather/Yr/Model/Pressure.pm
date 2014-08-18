package Weather::Yr::Model::Pressure;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'hPa' => ( isa => 'Num', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
