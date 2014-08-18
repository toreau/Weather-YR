package Weather::Yr::Model::Precipitation;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'value' => ( isa => 'Num',        is => 'rw', required => 1 );
has 'min'   => ( isa => 'Maybe[Num]', is => 'rw', required => 0, default => 0 );
has 'max'   => ( isa => 'Maybe[Num]', is => 'rw', required => 0, default => 0 );

has 'symbol' => ( isa => 'Weather::Yr::Model::Precipitation::Symbol', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
