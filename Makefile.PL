use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::ReadmeMarkdownFromPod;

name 'App-GlitchIME';
all_from 'lib/App/GlitchIME.pm';
readme_markdown_from('lib/App/GlitchIME.pm');

requires 'URI';
requires 'LWP::UserAgent';
requires 'JSON';

test_requires 'Test::More';

author_tests('xt');
auto_set_repository();
WriteAll;
