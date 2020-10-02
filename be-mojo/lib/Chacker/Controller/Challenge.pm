package Chacker::Controller::Challenge;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub list ($c) {
  my $challenges = $c->model('challenge')->list;
  return $c->api->cool($challenges);
}

sub add ($c) {
  my $challenge = $c->req->json;
  my $ch_id     = $c->model('challenge')->add($challenge);
  return $c->api->cool({id => $ch_id});
}

sub update ($c) {
  my $challenge_id     = $c->param('id');
  my $fields_to_update = $c->req->json;

  $challenge_id = $c->model('challenge')->update($challenge_id, $fields_to_update);

  return $c->api->cool({id => $challenge_id});
}

1;
