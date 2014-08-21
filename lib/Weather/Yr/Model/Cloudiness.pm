package Weather::YR::Model::Cloudiness;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Model';

has 'percent' => ( isa => 'Maybe[Num]', is => 'ro', required => 0 );

__PACKAGE__->meta->make_immutable;

1;
