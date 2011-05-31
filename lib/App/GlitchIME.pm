package App::GlitchIME;
use strict;
use warnings;

use 5.00801;

use Carp ();
use JSON ();
use LWP::UserAgent;
use URI;

our $VERSION = '0.01';

sub new {
    my ($class, $text) = @_;
    Carp::croak("Error: not specified argument") unless defined $text;
    bless { text => $text, _candidates => undef }, __PACKAGE__;
}

sub generate {
    my $self = shift;
    $self->{_candidates} ||= $self->_get_candidates;

    my $result = '';
    for my $segment (@{$self->{_candidates}}) {
        my ($segment, $candidates) = @{$segment};
        $result .= _choice($candidates);
    }

    return $result;
}

sub _get_candidates {
    my $self = shift;

    my $ua = LWP::UserAgent->new(agent => __PACKAGE__ . "/$VERSION");
    $ua->env_proxy;

    my $uri = URI->new("http://www.google.com/transliterate");
    $uri->query_form(
        langpair => 'ja-Hira|ja',
        text     => $self->{text},
    );

    my $res = $ua->get($uri);
    if ( $res->is_error ) {
        Carp::croak("Can't download $uri");
    }

    return JSON::decode_json($res->decoded_content);
}

sub _choice {
    my $array_ref = shift;
    my $length = scalar @{$array_ref};

    return $array_ref->[ int(rand($length)) ];
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

App::GlitchIME - Japanese translation with Google translation API

=head1 SYNOPSIS

  use App::GlitchIME;

  binmode STDOUT, ":utf8";

  my $ime = App::GlitchIME->new($japanse_sentence);

  for (1..10) {
      print $ime->generate, "\n";
  }

=head1 DESCRIPTION

App::GlitchIME is perl version of B<glitch-ime>(written in Ruby).

=head1 METHODS

=over 4

=item my $ime = App::GlitchIME->new($text)

This method creates new instance of App::GlitchIME

C<$text> argument should be Japanese B<HIRAGANA>.
And it should be octet stream.

=item my $str = $img->generate();

This method returns string which is concatenated candidate of each segment.
Choice of candidate is random. So you may get another string when you
call this method next time.

=back

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2011- Syohei YOSHIDA

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

Original code in Ruby language by hitode909
L<http://d.hatena.ne.jp/hitode909/20110221>.

Guide of translation API L<http://www.google.co.jp/intl/ja/ime/cgiapi.html>

=cut
