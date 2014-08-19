package Weather::Yr::Base;
use Moose;
use namespace::autoclean;

use LWP::UserAgent;
use XML::Bare;
use DateTime;
use DateTime::Format::ISO8601;
use DateTime::TimeZone;

has 'lat'  => ( isa => 'Num', is => 'rw', required => 1 );
has 'lon'  => ( isa => 'Num', is => 'rw', required => 1 );
has 'msl'  => ( isa => 'Int', is => 'rw', required => 0, default => 0 );
has 'lang' => ( isa => 'Str', is => 'rw', required => 0, default => 'nb' );
has 'tz'   => ( isa => 'DateTime::TimeZone', is => 'rw', required => 0, default => sub { DateTime::TimeZone->new(name => 'UTC'); } );

has 'ua' => ( isa => 'LWP::UserAgent', is => 'rw', default => sub { return LWP::UserAgent->new; } );

has 'xml'     => ( isa => 'Maybe[Str]',     is => 'ro', lazy_build => 1 );
has 'xml_ref' => ( isa => 'Maybe[HashRef]', is => 'ro', lazy_build => 1 );

sub _build_xml {
    my $self = shift;

    my $response = $self->ua->get( $self->url );

    if ( $response->is_success ) {
        return $response->decoded_content;
    }
    else {
        return undef;
    }
}

sub _build_xml_ref {
    my $self = shift;

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
