package Weather::Yr::Model::Dewpoint;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model::Temperature';

has '+celsius' => ( isa => 'Maybe[Num]', is => 'rw', required => 1 );

1;
