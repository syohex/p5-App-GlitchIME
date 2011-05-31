use strict;
use Test::More;

use App::GlitchIME;

my $app = App::GlitchIME->new("あいうえお");
isa_ok($app, "App::GlitchIME", "constructor");

eval {
    my $app2 = App::GlitchIME->new()
};
like $@, qr{not specified argument}, "no argument";

can_ok($app, "generate");
{
    use utf8;
    my $candidates = [
        [ 'あ', [ 'aaa', ] ]
    ];
    $app->{_candidates} = $candidates;

    my $str = $app->generate;
    is $str, "aaa";
}

done_testing;
