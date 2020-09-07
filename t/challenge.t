use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::Collection 'c';

my $t = Test::Mojo->new('Chacker');

subtest 'create challenge' => sub {
  my $challenge = {
    title       => 'test_challenge',
    description => 'test_description',
    tasks       => [{title => 'Task#1', description => 'Description for task#1', type => 'days',},],
  };

  $t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)->status_is(200)
    ->json_like('/id' => qr/^\d+$/);
  my $created_challenge_id = $t->tx->res->json->{id};

  $t->get_ok('/api/challenge')->status_is(200)->json_has('/challenges/0');
  my $challenge_from_api = c(@{$t->tx->res->json->{challenges}})->first(sub {
    $_->{id} eq $created_challenge_id;
  });
  ok defined($challenge_from_api), 'created challenge is listed';
};

my $fields_to_update
  = {description => 'New description!', title => 'New title!', days => {add => ['2020-09-07', '2020-09-08']}};

$t->put_ok('/api/task/1' => {Accept => '*/*'} => json => $fields_to_update);

&done_testing;
