package Weather::YR::Base;
use Moose;
use namespace::autoclean;

use DateTime::Format::ISO8601;
use DateTime::TimeZone;
use DateTime;
use LWP::UserAgent;
use XML::Bare;

has [ 'lat', 'lon', 'msl' ] => (
    isa      => 'Maybe[Num]',
    is       => 'rw',
    required => 0,
    default  => 0,
);

has 'xml' => (
    isa      => 'Maybe[Str]',
    is       => 'rw',
    required => 0,
);

has 'lang' => (
    isa      => 'Maybe[Str]',
    is       => 'rw',
    required => 0,
    default  => 'nb',
);

has 'tz' => (
    isa      => 'DateTime::TimeZone',
    is       => 'rw',
    required => 0,
    default  => sub { DateTime::TimeZone->new( name => 'UTC' ); },
);

has 'ua' => (
    isa      => 'LWP::UserAgent',
    is       => 'rw',
    required => 0,
    default  => sub { LWP::UserAgent->new; },
);

has 'xml_ref' => (
    isa        => 'Maybe[HashRef]',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_xml_ref {
    my $self = shift;

    unless ( length $self->xml ) {
        my $response = $self->ua->get( $self->url );

        if ( $self->can('status_code') ) {
            $self->status_code( $response->code );
        }

        if ( $response->is_success ) {
            $self->xml( $response->decoded_content );
        }
    }

    return XML::Bare->new( text => $self->xml )->parse;
}

sub date_to_datetime {
    my $self = shift;
    my $date = shift // '';

    if ( length $date ) {
        $date = DateTime::Format::ISO8601->parse_datetime( $date );
    }
    else {
        $date = DateTime->now;
    }

    $date->set_time_zone( $self->tz );

    return $date;
}


__PACKAGE__->meta->make_immutable;

1;
