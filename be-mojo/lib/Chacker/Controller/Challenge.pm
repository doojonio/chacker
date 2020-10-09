package Chacker::Controller::Challenge;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub list ($c) {
  return $c->api->cool($challenges);
}

sub add ($c) {
  my $challenge = $c->req->json;
  return $c->api->cool({id => $ch_id});
}

sub update ($c) {
  my $challenge_id     = $c->param('id');
  my $fields_to_update = $c->req->json;

  return $c->api->cool({id => $challenge_id});
}

1;
