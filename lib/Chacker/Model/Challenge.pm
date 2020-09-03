package Chacker::Model::Challenge;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_challenges => 'challenges';
has f_challenges => sub{c(qw'id title description')};

sub add ($m, $challenge) {
  my $choped_ch = $m->app->chop($challenge, $m->f_challenges);
  $m->app->db->insert($m->t_challenges, $choped_ch, { returning => 'id' })->hash->{id};
}

1;
