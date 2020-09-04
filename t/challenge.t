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
      type        => 'checklist',
      items       => [
        {
          title   => 'Read book',
          checked => \1,
        },
        {
          title   => 'Do 25 pushups',
          checked => \0,
        },
      ],
    },
  ],
};

$t->post_ok('/api/challenge' => {Accept => '*/*'} => json => $challenge)->json_like('/id' => qr/^\d+$/);

&done_testing;
