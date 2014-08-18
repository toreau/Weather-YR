package Weather::Yr::Model::Fog;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'percent' => ( isa => 'Maybe[Num]', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
