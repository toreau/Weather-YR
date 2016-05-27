package Weather::YR::Lang::Symbol;
use Moose;
use namespace::autoclean;

has 'number' => ( isa => 'Int', is => 'rw', required => 1 );
has 'lang'   => ( isa => 'Str', is => 'rw', required => 1 );

has 'text'   => ( isa => 'Str', is => 'ro', lazy_build => 1 );

our $TRANSLATIONS = {
    1 => {
        en => 'Sun/clear',
        nb => 'Sol/klarvær',
    },
    2 => {
        en => 'Fair',
        nb => 'Lettskyet',
    },
    3 => {
        en => 'Partly cloudy',
        nb => 'Delvis skyet',
    },
    4 => {
        en => 'Cloudy',
        nb => 'Skyet',
    },
    5 => {
        en => 'Light rain showers',
        nb => 'Lette regnbyger',
    },
    6 => {
        en => 'Light rain showers and thunder',
        nb => 'Lette regnbyger og torden',
    },
    7 => {
        en => 'Snow flurries',
        nb => 'Sluddbyger',
    },
    8 => {
        en => 'Snow showers',
        nb => 'Snøbyger',
    },
    9 => {
        en => 'Rain',
        nb => 'Regn',
    },
    10 => {
        en => 'Heavy rain',
        nb => 'Kraftig regn',
    },
    11 => {
        en => 'Rain and thunder',
        nb => 'Regn og torden',
    },
    12 => {
        en => 'Sleet',
        nb => 'Sludd',
    },
    13 => {
        en => 'Snow',
        nb => 'Snø',
    },
    14 => {
        en => 'Snow and thunder',
        nb => 'Snø og torden',
    },
    15 => {
        en => 'Fog',
        nb => 'Tåke',
    },
    20 => {
        en => 'Snow flurries and thunder',
        nb => 'Sluddbyger og torden',
    },
    21 => {
        en => 'Snow showers and thunder',
        nb => 'Snøbyger og torden',
    },
    22 => {
        en => 'Rain showers and thunder',
        nb => 'Regnbyger og torden',
    },
    23 => {
        en => 'Sleet and thunder',
        nb => 'Sludd og torden',
    },
    24 => {
        en => 'Drizzle showers and thunder',
        nb => 'Yrbyger og torden',
    },
    25 => {
        en => 'Thundershowers',
        nb => 'Tordenbyger',
    },
    26 => {
        en => 'Rain showers and thunder',
        nb => 'Regnbyger og torden',
    },
    27 => {
        en => 'Heavy snow and thunder',
        nb => 'Kraftige sluddbyger og torden',
    },
    28 => {
        en => 'Light snow showers and thunder',
        nb => 'Lette snøbyger og torden',
    },
    29 => {
        en => 'Heavy snow showers and thunder',
        nb => 'Kraftige snøbyger og torden',
    },
    30 => {
        en => 'Light drizzle and thunder',
        nb => 'Yr og torden',
    },
    31 => {
        en => 'Light sleep showers and thunder',
        nb => 'Lette sluddbyger og torden',
    },
    32 => {
        en => 'Heavy sleet and thunder',
        nb => 'Kraftig sludd og torden',
    },
    33 => {
        en => 'Light snowfall and thunder',
        nb => 'Lett snøfall og torden',
    },
    34 => {
        en => 'Heavy snowfall and thunder',
        nb => 'Kraftig snøfall og torden',
    },
    40 => {
        en => 'Light rain showers',
        nb => 'Yrbyger',
    },
    41 => {
        en => 'Rain showers',
        nb => 'Regnbyger',
    },
    42 => {
        en => 'Light sleet showers',
        nb => 'Lette sluddbyger',
    },
    43 => {
        en => 'Heavy sleet showers',
        nb => 'Kraftige sluddbyger',
    },
    44 => {
        en => 'Light snow showers',
        nb => 'Lette snøbyger',
    },
    45 => {
        en => 'Heavy snow showers',
        nb => 'Kraftige snøbyger',
    },
    46 => {
        en => 'Drizzle',
        nb => 'Yr',
    },
    47 => {
        en => 'Light sleet',
        nb => 'Lett sludd',
    },
    48 => {
        en => 'Heavy sleet',
        nb => 'Kraftig sludd',
    },
    49 => {
        en => 'Light snow fall',
        nb => 'Lett snø',
    },
    50 => {
        en => 'Heavy snow fall',
        nb => 'Kraftig snøfall',
    },

    # Polar night
    101 => {
        en => 'Sun/clear (polar night)',
        nb => 'Sol/klarvær (mørketid)',
    },
    102 => {
        en => 'Fair (polar night)',
        nb => 'Lettskyet (mørketid)',
    },
    103 => {
        en => 'Partly cloudy (polar night)',
        nb => 'Delvis skyet (mørketid)',
    },
    105 => {
        en => 'Rain showers (polar night)',
        nb => 'Regnbyger (mørketid)',
    },
    106 => {
        en => 'Rain showers with thunder (polar night)',
        nb => 'Regnbyger med torden (mørketid)',
    },
    107 => {
        en => 'Snow flurry showers (polar night)',
        nb => 'Sluddbyger (mørketid)',
    },
    108 => {
        en => 'Snow showers (polar night)',
        nb => 'Snøbyger (mørketid)',
    },
    120 => {
        en => 'Snow flurry showers with thunder (polar night)',
        nb => 'Sluddbyger med torden (mørketid)',
    },
    121 => {
        en => 'Snow showers with thunder (polar night)',
        nb => 'Snøbyger med torden (mørketid)',
    },
    124 => {
        en => 'Drizzle and thunder (polar night)',
        nb => 'Yrbyger og torden (mørketid)',
    },
    125 => {
        en => 'Thundershowers (polar night)',
        nb => 'Tordenbyger (mørketid)',
    },
    126 => {
        en => 'Rain showers and thunder (polar night)',
        nb => 'Regnbyger og torden (mørketid)',
    },
    127 => {
        en => 'Heavy snow sleet with thunder (polar night)',
        nb => 'Kraftige sluddbyger og torden (mørketid)',
    },
    128 => {
        en => 'Light snow showers and thunder (polar night)',
        nb => 'Lette snøbyger og torden (mørketid)',
    },
    129 => {
        en => 'Heavy snow showers and thunder (polar night)',
        nb => 'Kraftige snøbyger og torden (mørketid)',
    },
    140 => {
        en => 'Drizzle showers and thunder (polar night)',
        nb => 'Yrbyger (mørketid)',
    },
    141 => {
        en => 'Rain showers (polar night)',
        nb => 'Regnbyger (mørketid)',
    },
    142 => {
        en => 'Light sleet showers (polar night)',
        nb => 'Lette sluddbyger (mørketid)',
    },
    143 => {
        en => 'Heavy sleet showers (polar night)',
        nb => 'Kraftige sluddbyger (mørketid)',
    },
    144 => {
        en => 'Light snow showers (polar night)',
        nb => 'Lette snøbyger (mørketid)',
    },
    145 => {
        en => 'Heavy snow showers (polar night)',
        nb => 'Kraftige snøbyger (mørketid)',
    },
};

sub _build_text {
    my $self = shift;

    return $TRANSLATIONS->{ $self->number }->{ $self->lang };
}

__PACKAGE__->meta->make_immutable;

1;
