use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Chacker');

my $challenge = {
  title       => 'test_challenge',
  description => 'test_description',
  tasks       => [
    {
      title       => 'Task#1',
      description => 'Description for task#1',
      type        => 'days',
    },
  ],
};

$t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)
  ->status_is(200)
  ->json_like('/id' => qr/^\d+$/);

$t->get_ok('/api/challenge')
  ->status_is(200)
  ->json_has('/challenges/1');

my $fields_to_update = {
  description => 'New description!',
  title => 'New title!',
  days => {
    add => ['2020-09-07', '2020-09-08'],
  },
};

$t->put_ok('/api/task/1' => {Accept => '*/*'} => json => $fields_to_update);

&done_testing;
