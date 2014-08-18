package Weather::Yr::Day;
use Moose;
use namespace::autoclean;

has 'date'       => ( isa => 'DateTime',                         is => 'rw', required => 1 );
has 'datapoints' => ( isa => 'ArrayRef[Weather::Yr::DataPoint]', is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
