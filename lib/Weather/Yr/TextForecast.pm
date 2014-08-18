package Weather::Yr::TextForecast;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Base';

__PACKAGE__->meta->make_immutable;

1;
