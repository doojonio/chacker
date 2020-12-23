package Chacker::Controller::Challenge;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Clone 'clone';

has challenges => sub { state $challenges = shift->schema->resultset('Challenge') };

has _insert_challenge_fields => sub { [qw/title description/] };
has _insert_task_fields      => sub { [qw/title type/] };

sub get ($c) {
  my @challenges;
  if (my $challenge_id = $c->param('id')) {
    @challenges = $c->challenges->find($challenge_id) // return $c->api->sad({error => 'Not found',});
  }
  else {
    @challenges = $c->challenges->all;
  }
  my @ch_h;
  for my $ch (@challenges) {
    my %ch_h = $ch->get_columns;
    my @tasks_h;
    for my $task ($ch->tasks) {
      push @tasks_h, {$task->get_columns};
    }
    $ch_h{tasks} = \@tasks_h;

    push @ch_h, \%ch_h;
  }
  return $c->api->cool(\@ch_h);
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