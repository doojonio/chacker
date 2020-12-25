package Chacker::Controller::Challenge;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Clone 'clone';

has challenges => sub { state $challenges = shift->schema->resultset('Challenge') };

has _insert_challenge_fields => sub { [qw/title description picture/] };
has _insert_task_fields      => sub { [qw/title description type picture/] };

sub get ($c) {
  my $challenge_id = $c->param('challenge_id');

  my $ch = $c->challenges->find($challenge_id)
    || return $c->api->sad({error => "no challenge with id = $challenge_id found"});
  my %response = $ch->get_columns;
  $response{picture} = $ch->picture->path;

  my @tasks_h;
  for my $task ($ch->tasks) {
    push @tasks_h, {
      $task->get_columns, picture => $task->picture->path
    };
  }

  $response{tasks} = \@tasks_h;

  return $c->api->cool(\%response);
}

sub list ($c) {
  my @challenges = $c->challenges->all;
  my @response;
  for my $ch (@challenges) {
    push @response, {$ch->get_columns};
  }
  return $c->api->cool(\@response);
}

sub add ($c) {
  my $challenge = $c->req->json;

  my ($is_challenge, @errors) = $c->is_challenge_hash($challenge);

  if (!$is_challenge) {
    return $c->api->sad({error => \@errors});
  }

  $challenge->{state} = 'new';
  for my $task (@{$challenge->{tasks}}) {
    $task->{state} = 'new';
  }

  my $inserted = $c->challenges->create($challenge);
  return $c->api->cool({id => $inserted->id});
}

sub is_challenge_hash ($c, $hash) {
  my $challenge = clone($hash);
  my @errors;
  my $tasks;

  if ($challenge->{tasks}) {
    $tasks = delete $challenge->{tasks};
  }
  else {
    push @errors, 'no tasks provided';
    $tasks = [];
  }

  my ($is_challenge_ok, @challenge_errors) = $c->_is_hash_correct($challenge, $c->_insert_challenge_fields);

  push @errors, @challenge_errors unless $is_challenge_ok;

  for my $task (@$tasks) {
    my ($is_task_ok, @task_errors) = $c->_is_hash_correct($task, $c->_insert_task_fields);
    push @errors, @task_errors unless $is_task_ok;
  }

  return 1 unless @errors;
  return 0, @errors;
}

sub _is_hash_correct ($c, $hash, $required_fields) {
  my $hash_copy = clone($hash);
  my @errors;

  for my $r (@$required_fields) {
    unless (delete $hash_copy->{$r}) {
      push @errors, "required field $r wasn't provided";
    }
  }

  for (keys %$hash_copy) {
    push @errors, "field $_ is extra field";
  }

  return 1 unless @errors;
  return 0, @errors;
}

1
