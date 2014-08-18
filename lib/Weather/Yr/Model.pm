package Weather::Yr::Model;
use Moose;
use namespace::autoclean;

has 'from' => ( isa => 'DateTime', is => 'rw', required => 1 );
has 'to'   => ( isa => 'DateTime', is => 'rw', required => 1 );
has 'lang' => ( isa => 'Str',      is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;

1;
