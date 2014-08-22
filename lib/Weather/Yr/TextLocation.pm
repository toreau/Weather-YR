package Weather::YR::TextLocation;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Base';

has 'lang' => ( isa => 'Str', is => 'rw', default => 'nb' );

has 'url' => ( isa => 'Str', is => 'ro', lazy_build => 1 );

sub _build_url {
    my $self = shift;

    return 'http://api.yr.no/weatherapi/textlocation/1.0/?latitude=' . $self->lat . ';longitude=' . $self->lon . ';language=' . $self->lang;
}

__PACKAGE__->meta->make_immutable;

1;
