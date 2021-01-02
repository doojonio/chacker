use Mojo::Base -strict;

use Clone qw(clone);
use Mojo::Collection qw(c);
use Mojo::File qw(path curfile);
use Test::Mojo;
use Test::More;

my $t = Test::Mojo->new('Chacker');

my $samples       = curfile->sibling('samples');
my $example_image = path($samples, 'image.png')->to_string;

my $common_test_challenge = {
  title       => 'test_challenge',
  description => 'test_description',
  picture     => undef,
  tasks       => [{title => 'Task#1', description => 'Tzuyu...', type => 'days', picture => undef},],
};

subtest 'upload image' => sub {
  my $form = {image => {file => $example_image},};
  $t->post_ok('/api/upload/image', form => $form)->status_is(200)->json_has('/id');

  # fill for following tests
  my $uploaded_image = $t->tx->res->json;
  $common_test_challenge->{picture} = $uploaded_image;
  $_->{picture}                     = $uploaded_image for @{$common_test_challenge->{tasks}};
};

subtest 'create challenge' => sub {
  my $challenge = clone($common_test_challenge);
  $t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)->status_is(200)->json_has('/id')
    ->json_like('/id' => qr/^\d+$/);
  my $created_challenge_id = $t->tx->res->json->{id};

  $t->get_ok('/api/challenge')->status_is(200)->json_has('/0');
  my $challenge_from_api = c(@{$t->tx->res->json})->first(sub {
    $_->{id} eq $created_challenge_id;
  });
  ok defined($challenge_from_api), 'created challenge is listed';
};

subtest 'challenge create fails' => sub {
  my $challenge = {};
  $t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)->status_is(400)->json_has('/error');
};

subtest 'get task' => sub {
  $t->get_ok('/api/task/1')->status_is(200)->json_has('/days');
};

subtest 'get challenge' => sub {
  $t->get_ok('/api/challenge/1')->status_is(200)->json_has('/picture')->json_like('/picture/path' => qr/^\w{4}\//);
};

&done_testing;
