package Weather::YR::Model::Humidity;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Model';

has 'percent' => ( isa => 'Maybe[Num]', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
