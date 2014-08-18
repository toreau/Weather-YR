package Weather::Yr::Model::Precipitation::Symbol;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'id'     => ( isa => 'Str', is => 'rw', required => 1 );
has 'number' => ( isa => 'Int', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
