package Weather::Yr::LocationForecast::Day;
use Moose;
use namespace::autoclean;

extends 'Weather::Yr::Day';

has 'temperatures'    => ( isa => 'ArrayRef[Weather::Yr::Model::Temperature]', is => 'ro', lazy_build => 1 );
has 'temperature'     => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );

has 'min_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );
has 'max_temperature' => ( isa => 'Weather::Yr::Model::Temperature',           is => 'ro', lazy_build => 1 );

has 'precipitations' => ( isa => 'ArrayRef[Weather::Yr::Model::Precipitation]', is => 'ro', lazy_build => 1 );
has 'precipitation'  => ( isa => 'Weather::Yr::Model::Precipitation',           is => 'ro', lazy_build => 1 );

=head1 METHODS

=head2 temperatures

Returns an array reference of all the L<Weather::Yr::Model::Temperature>
data points for this day.

=cut

sub _build_temperatures {
    my $self = shift;

    return [ map { $_->temperature } @{$self->datapoints} ];
}

sub _asc_sorted_temperatures {
    my $self = shift;

    return [ sort {
        $a->celsius <=> $b->celsius
    } @{ $self->temperatures } ];
}

=head2 temperature

Returns the "most logical" L<Weather::Yr::Model::Temperature> data point for
this day.

This works so that if you are working with "now", it will pick the data point
closes to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_temperature {
    my $self = shift;

    foreach ( @{$self->temperatures} ) {
        if ( $_->from->hour == 12 ) {
            return $_;
        }
    }

    return $self->temperatures->[0];
}

=head2 min_temperature

Returns the L<Weather::Yr::Model::Temperature> data point with the lowest
temperature value for this day.

=cut

sub _build_min_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[0];
}

=head2 min_temperature

Returns the L<Weather::Yr::Model::Temperature> data point with the highest
temperature value for this day.

=cut

sub _build_max_temperature {
    my $self = shift;

    return $self->_asc_sorted_temperatures->[-1];
}

=head2 precipitations

Returns an array reference of all the L<Weather::Yr::Model::Precipitation>
data points for this day.

=cut

sub _build_precipitations {
    my $self = shift;

    my @precips = ();

    foreach ( @{$self->datapoints} ) {
        foreach ( @{$_->precipitations} ) {
            if ( $_->from->ymd eq $self->date->ymd ) {
                push( @precips, $_ );
            }
        }
    }

    return \@precips;
}

=head2 precipitation

Returns "the most logical" L<Weather::Yr::Model::Precipitation> data point
for this day.

This works so that if you are working with "now", it will pick the data point
closes to the current time. If you are working with any other days, including
"today", it will return the noon data point.

=cut

sub _build_precipitation {
    my $self = shift;

    foreach ( @{$self->precipitations} ) {
        if ( $_->from->hour == 12 ) {
            return $_;
        }
    }

    return $self->precipitations->[0];
}

__PACKAGE__->meta->make_immutable;

1;

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
