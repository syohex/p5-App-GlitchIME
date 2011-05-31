#!/usr/bin/env perl
use strict;
use warnings;

use lib "../lib";

use Encode;
use App::GlitchIME;

my $input = shift or die "Usage: $0 japanse_sentence";
my $decoded = decode_utf8($input);

my $text;
if ((length $decoded) % 2 == 0) {
    $text = $decoded . reverse $decoded;
} else {
    $text = $decoded . reverse(substr $decoded, 0, -1);
}

my $ime = App::GlitchIME->new(encode_utf8($text));

for (1..10) {
    print encode_utf8($ime->generate), "\n";
}
