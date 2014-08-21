package Weather::YR::Model::DewPointTemperature;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Model::Temperature';

has '+celsius' => ( isa => 'Maybe[Num]', is => 'rw', required => 1 );

1;
