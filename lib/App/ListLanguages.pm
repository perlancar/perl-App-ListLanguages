package App::ListLanguages;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

our %SPEC;
use Exporter qw(import);
our @EXPORT_OK = qw(list_languages);

our $data;
{
    require Locale::Codes::Language_Codes;
    $data = [];
    my $id2names  = $Locale::Codes::Data{'language'}{'id2names'};
    my $id2alpha2 = $Locale::Codes::Data{'language'}{'id2code'}{'alpha-2'};
    my $id2alpha3 = $Locale::Codes::Data{'language'}{'id2code'}{'alpha-3'};

    for my $id (keys %$id2names) {
        next unless $id2alpha3->{$id};
        push @$data, [$id2alpha3->{$id}, $id2alpha2->{$id}, $id2names->{$id}[0]];
    }

    $data = [sort {$a->[0] cmp $b->[0]} @$data];
}

my $res = gen_read_table_func(
    name => 'list_languages',
    summary => 'List languages',
    table_data => $data,
    table_spec => {
        summary => 'List of languages',
        fields => {
            alpha3 => {
                summary => 'ISO 639 3-letter code',
                schema => 'str*',
                pos => 0,
                sortable => 1,
            },
            alpha2 => {
                summary => 'ISO 639 2-letter code',
                schema => 'str*',
                pos => 1,
                sortable => 1,
            },
            en_name => {
                summary => 'English name',
                schema => 'str*',
                pos => 2,
                sortable => 1,
            },
        },
        pk => 'alpha3',
    },
    description => <<'_',

Source data is generated from `Locale::Codes::Language_Codes`. so make sure you
have a relatively recent version of the module.

_
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via list-languages CLI script


=head1 SEE ALSO

L<Locale::Codes>

L<list-countries> from L<App::ListCountries>

L<list-currencies> from L<App::ListCurrencies>

=cut
