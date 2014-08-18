package Weather::Yr::Model::WindSpeed;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'mps'      => ( isa => 'Num', is => 'rw', required => 1 );
has 'beaufort' => ( isa => 'Num', is => 'rw', required => 1 );
has 'name'     => ( isa => 'Str', is => 'rw', required => 1 );

has 'fps' => ( isa => 'Num', is => 'ro', lazy_build => 1 );

sub _build_fps {
    my $self = shift;

    return sprintf( '%.1f', $self->mps * 3.28083989501312 );
}

__PACKAGE__->meta->make_immutable;

1;
