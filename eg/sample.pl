#!/usr/bin/env perl
use strict;
use warnings;

use lib "../lib";
use App::GlitchIME;

binmode STDOUT, ":utf8";

my $text = shift or die "Usage: $0 japanse_sentense";
my $ime = App::GlitchIME->new($text);

for (1..10) {
    print $ime->generate, "\n";
}
