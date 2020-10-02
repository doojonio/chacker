package Chacker::Model::Challenge;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_challenges           => 'challenges';
has f_challenges           => sub { [qw'id title description state'] };
has f_updatable_challenges => sub { [qw'title description state'] };

sub list ($m) {
  my $challenges = $m->app->db->select($m->t_challenges, $m->f_challenges)->hashes->each(sub {
    $_->{tasks} = $m->app->model('challenge-task')->list($_->{id});
  });
  return $challenges->to_array;
}

sub add ($m, $challenge) {
  my $choped_ch = $m->app->chop($challenge, $m->f_challenges);
  $choped_ch->{state} //= 'new';
  my $id = $m->app->db->insert($m->t_challenges, $choped_ch, {returning => 'id'})->hash->{id};
  $m->app->model('challenge-task')->add($id, c(@{$challenge->{tasks}}));
  return $id;
}

sub update ($m, $challenge_id, $fields_to_update) {
  $fields_to_update = $m->_extract_updatable_fields($fields_to_update);
  $m->app->db->update($m->t_challenges, $fields_to_update, {id => $challenge_id});
  return $challenge_id;
}

sub _extract_updatable_fields ($m, $fields_to_update) {
  my %extracted_fields;

  for (@{$m->f_updatable_challenges}) {
    $extracted_fields{$_} = $fields_to_update->{$_} if defined($fields_to_update->{$_});
  }

  die 'No fields to update found' unless %extracted_fields;
  return \%extracted_fields;
}

1;
