use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::Collection 'c';

use Clone 'clone';

my $t = Test::Mojo->new('Chacker');

my $common_test_challenge = {
  title       => 'test_challenge',
  description => 'test_description',
  tasks       => [{title => 'Task#1', description => 'Tzuyu...', type => 'days',},],
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

subtest 'record day' => sub {
  my $days_to_record = {days => ['1999-06-14', '2000-02-12'],};

  $t->post_ok('/api/task/1/record' => {Accept => '*/*'} => json => $days_to_record)->status_is(200);
};

subtest 'get task' => sub {
  $t->get_ok('/api/task/1')->status_is(200)->json_has('/days');
};

&done_testing;
