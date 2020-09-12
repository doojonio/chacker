use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::Collection 'c';

use Clone 'clone';

my $t = Test::Mojo->new('Chacker');

my $common_test_challenge = {
  title       => 'test_challenge',
  description => 'test_description',
  tasks       => [{title => 'Task#1', description => 'Description for task#1', type => 'days',},],
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

subtest 'update task' => sub {
  my $fields_to_update
    = {description => 'New description!', title => 'New title!', days => {add => ['2020-09-07', '2020-09-08']}};

  $t->put_ok('/api/task/1' => {Accept => '*/*'} => json => $fields_to_update);
};

subtest 'update challenge' => sub {
  my $challenge = clone($common_test_challenge);
  $t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)->status_is(200)
    ->json_like('/id' => qr/^\d+$/);

  my $created_challenge_id = $t->tx->res->json->{id};

  my $fields_to_update
    = {title => 'New title for challenge!', description => 'New challenge description', state => 'completed'};

  $t->put_ok("/api/challenge/$created_challenge_id" => {Accept => '*/*'} => json => $fields_to_update)->status_is(200)
    ->json_has('/id')->json_is('/id' => $created_challenge_id);

  $t->get_ok('/api/challenge');

  my $updated_challenge_from_api = c(@{$t->tx->res->json})->first(sub {
    $_->{id} eq $created_challenge_id;
  });

  for (keys %$fields_to_update) {
    ok $updated_challenge_from_api->{$_} eq $fields_to_update->{$_}, "$_ updated";
  }
};

&done_testing;
