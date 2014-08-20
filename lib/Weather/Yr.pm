package Weather::YR;
use Moose;
use namespace::autoclean;

extends 'Weather::YR::Base';

use Weather::YR::LocationForecast;
use Weather::YR::TextLocation;

=head1 NAME

Weather::YR - Object-oriented interface to YR.no's weather service.

=head1 VERSION

Version 0.30.

=cut

our $VERSION = '0.31';

=head1 SYNOPSIS

    use Weather::YR;
    use DateTime::TimeZone;

    my $yr = Weather::YR->new(
        lat => 63.590833,
        lon => 10.741389,
        tz  => DateTime::TimeZone->new( name => 'Europe/Oslo' ),
    );

    foreach my $day ( @{$yr->location_forecast->days} ) {
        say $day->date . ':';
        say ' ' x 4 . 'Min. temperature = ' . $day->min_temperature->celsius;
        say ' ' x 4 . 'Max. temperature = ' . $day->max_temperature->celsius;

        foreach my $dp ( @{$day->datapoints} ) {
            say ' ' x 4 . 'Wind direction: ' . $dp->wind_direction->name;
        }
    }

    # If you are interested in the weather right now (*):

    my $now = $yr->location_forecast->now;

    say "It's " . $now->temperature->celsius . "C outside.";
    say "Weather status: " . $now->temperature->precipitation->symbol->text;

    # (*) "Right now" is actually lying, as the data from Yr is always
    #     a _forecast_, ie. what the weather will be like. The now()
    #     method simply picks the closest one in time.

=head1 DESCRIPTION

** THIS IS PRE-ALPHA! DO NOT USE IN PRODUCTION! INTERFACE WILL CHANGE! **

This is an object-oriented interface to Yr.no's free weather service located at
L<http://api.yr.no/>.

=cut

has 'location_forecast' => ( isa => 'Weather::YR::LocationForecast', is => 'ro', lazy_build => 1 );
# has 'text_location'     => ( isa => 'Weather::YR::TextLocation',     is => 'ro', lazy_build => 1 );

=head1 METHODS

=head2 location_forecast

Returns a L<Weather::YR::LocationForecast> instance.

=cut

sub _build_location_forecast {
    my $self = shift;

    return Weather::YR::LocationForecast->new(
        lat  => $self->lat,
        lon  => $self->lon,
        msl  => $self->msl,
        xml  => $self->xml,
        lang => $self->lang,
        tz   => $self->tz,
    );
}

# sub _build_text_location {
#     my $self = shift;

#     return Weather::YR::TextLocation->new(
#         lat  => $self->lat,
#         lon  => $self->lon,
#         lang => $self->lang,
#     );
# }

__PACKAGE__->meta->make_immutable;

1;

=head1 TODO

=over 4

=item * Improve the documentation.

=item * Add more tests.

=item * Add support for more of Yr.no's APIs.

=back

=head1 BUGS

Please report any bugs or feature requests via the github interface at
L<https://github.com/toreau/Weather-YR/issues>.

=head1 AUTHOR

Tore Aursand, C<< toreau@gmail.com >>

=head1 LICENSE AND COPYRIGHT

Copyright 2014, Tore Aursand.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
