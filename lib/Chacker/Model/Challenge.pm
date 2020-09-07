package Chacker::Model::Challenge;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_challenges => 'challenges';
has f_challenges => sub { [qw'id title description'] };

sub list ($m) {
  my $challenges = $m->app->db->select($m->t_challenges, $m->f_challenges)->hashes->each(sub {
    $_->{tasks} = $m->app->model('challenge-task')->list($_->{id});
  });
  return $challenges->to_array;
}

sub add ($m, $challenge) {
  my $choped_ch = $m->app->chop($challenge, $m->f_challenges);
  my $id        = $m->app->db->insert($m->t_challenges, $choped_ch, {returning => 'id'})->hash->{id};
  $m->app->model('challenge-task')->add($id, c(@{$challenge->{tasks}}));
  return $id;
}

1;
