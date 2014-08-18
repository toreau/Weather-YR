package Weather::Yr::Model::Temperature;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'celsius' => ( isa => 'Num', is => 'rw', required => 1 );

has 'fahrenheit' => ( isa => 'Num', is => 'ro', lazy_build => 1 );
has 'kelvin'     => ( isa => 'Num', is => 'ro', lazy_build => 1 );

sub _build_fahrenheit {
    my $self = shift;

    my $fahrenheit = ( ($self->celsius * 9) / 5 ) + 32;

    return sprintf( '%.2f', $fahrenheit );
}

sub _build_kelvin {
    my $self = shift;

    return sprintf( '%.2f', $self->celsius + 273.15 );
}

1;
