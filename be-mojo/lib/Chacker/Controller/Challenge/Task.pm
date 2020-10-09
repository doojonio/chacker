package Chacker::Controller::Challenge::Task;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub update ($c) {
  my $fields_to_update = $c->req->json;
  my $task_id          = $c->param('id');
  return $c->api->cool({id => $task_id});
}

1
