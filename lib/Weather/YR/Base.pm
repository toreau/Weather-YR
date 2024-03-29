package Weather::YR::Base;
use Moose;
use namespace::autoclean;

use DateTime::Format::ISO8601;
use DateTime::TimeZone;
use DateTime;
use LWP::UserAgent;
use Mojo::URL;
use XML::LibXML;
use XML::Simple;

has 'service_url' => (
    isa     => 'Mojo::URL',
    is      => 'ro',
    lazy    => 1,
    default => sub { Mojo::URL->new('https://api.met.no') },
);

has [ 'lat', 'lon', 'msl' ] => (
    isa      => 'Num',
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
    isa      => 'Str',
    is       => 'rw',
    required => 0,
    default  => 'en',
);

has 'tz' => (
    isa      => 'DateTime::TimeZone',
    is       => 'rw',
    required => 0,
    default  => sub { DateTime::TimeZone->new( name => 'UTC' ); },
);

has 'ua' => (
    isa      => 'Object',
    is       => 'rw',
    required => 0,
    default  => sub { LWP::UserAgent->new; },
);

has 'xml_ref' => (
    isa        => 'Maybe[HashRef]',
    is         => 'ro',
    lazy_build => 1,
);

# Make sure that 'lat' and 'lon' is restricted to four decimals, ref.
# https://api.met.no/doc/TermsOfService#traffic
around [ 'lat', 'lon' ] => sub {
    my $orig  = shift;
    my $self  = shift;
    my $value = shift || $self->$orig;

    $value = sprintf( '%0.4f', $value );

    return $self->$orig( $value );
};

sub _build_xml_ref {
    my $self = shift;

    unless ( length $self->xml ) {
        my $response = $self->ua->get( $self->url->to_string );

        if ( $self->can('status_code') ) {
            $self->status_code( $response->code );
        }

        if ( $response->is_success ) {
            $self->xml( $response->decoded_content );
        }
        else {
            warn "Failed to GET data from " . $self->url->to_string;
        }
    }

    if ( length $self->xml ) {
        if ( $self->can('schema_url') ) {
            eval {
                my $xml_doc  = XML::LibXML->new->load_xml( string => $self->xml );
                my $response = $self->ua->get( $self->schema_url->to_string );
                my $schema   = XML::LibXML::Schema->new( string => $response->decoded_content );

                $schema->validate( $xml_doc );
            };

            if ( $@ ) {
                warn "Failed to validate the XML returned from YR.no using schema URL '" . $self->schema_url . "'; $@";
            }
            else {
                my $result = undef;

                eval {
                    $result = XML::Simple::XMLin( $self->xml, ForceArray => 0 );
                };

                unless ( $@ ) {
                    return $result;
                }
            }
        }
    }
    else {
        warn "No XML to parse!";
    }

    # Something failed!
    return undef;
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
