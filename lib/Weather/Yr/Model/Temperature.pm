package Weather::Yr::Model::Temperature;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Model';

has 'celsius' => ( isa => 'Num', is => 'rw', required => 1 );

sub fahrenheit {
    my $self = shift;

    my $fahrenheit = ( ($self->celsius * 9) / 5 ) + 32;

    return sprintf( '%.2f', $fahrenheit );
}

sub kelvin {
    my $self = shift;

    return sprintf( '%.2f', $self->celsius + 273.15 );
}

1;
