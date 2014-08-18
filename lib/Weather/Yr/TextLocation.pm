package Weather::Yr::TextLocation;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Base';

has 'language' => ( isa => 'Str', is => 'rw', default => 'nb' );

has 'url' => ( isa => 'Str', is => 'ro', lazy_build => 1 );

sub _build_url {
    my $self = shift;

    return 'http://api.yr.no/weatherapi/textlocation/1.0/?latitude=' . $self->lat . ';longitude=' . $self->lon . ';language=' . $self->language;
}

__PACKAGE__->meta->make_immutable;

1;
