package Chacker::Controller::Challenge::Task;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub update ($c) {
  my $fields_to_update = $c->req->json;
  my $task_id = $c->param('id');
  $c->model('challenge-task')->update($task_id, $fields_to_update);
  return $c->api->cool(id => $task_id);
}

1
