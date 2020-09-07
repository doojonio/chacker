package Chacker::Model::Challenge::Task;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_tasks     => 'tasks';
has f_tasks     => sub{[qw'id challenge_id title type state']};

has f_updatable_tasks => sub{[qw'title state']};

has task_types  => sub{[qw'checklist days once']};
has task_states => sub{[qw'completed in_progress new failed']};

sub list ($m, $challenge_id) {
  my $tasks = $m->app->db->select($m->t_tasks, $m->f_tasks, { challenge_id => $challenge_id })
    ->hashes->each(sub {$m->_process_list_for_type($_)});
  return $tasks->to_array;
}

sub lookup($m, $task_id) {
  my $task = $m->app->db->select($m->t_tasks, $m->f_tasks, { id => $task_id })->hash;
  die "task#$task_id not found" unless $task->{id};
  return $task;
}

sub try_lookup($m, $task_id) {
  eval { $m->lookup($task_id) };
}

sub add ($m, $challenge_id, $tasks) {
  my $choped_tasks = c;
  $tasks->each(sub{
    $_->{challenge_id} = $challenge_id;
    $_->{state} //= 'new';
    push @$choped_tasks, $m->app->chop($_, $m->f_tasks);
  });
  $choped_tasks->each(sub ($task, $num) {
    my $id = $m->app->db->insert($m->t_tasks, $task, { returning => 'id' })->hash->{id};
    $tasks->[--$num]->{id} = $id;
  });
  return $tasks;
}

sub update ($m, $task_id, $fields_to_update) {
  my $upd_task_fields = $m->_try_extract_updatable_fields($fields_to_update);
  $m->app->db->update($m->t_tasks, $upd_task_fields, { id => $task_id })
    if $upd_task_fields;

  my $task = $m->lookup($task_id);
  my $need_update_by_type = $m->_check_for_update_by_type($task, $fields_to_update);

  $m->_process_update_for_type($task, $fields_to_update)
    if $need_update_by_type;

  return $task_id;
}

sub _try_extract_updatable_fields ($m, $fields_to_update) {
  my %extracted_fields;
  for (@{ $m->f_updatable_tasks }) {
    $extracted_fields{$_} = $fields_to_update->{$_}
      if defined $fields_to_update->{$_};
  }

  return unless %extracted_fields;
  return \%extracted_fields;
}

sub _check_for_update_by_type ($m, $task, $fields_to_update) {
  my $need_update;
  $need_update = $m->app->model('challenge-task-days')->check_for_update($fields_to_update)
    if $task->{type} eq 'days';

  return $need_update;
}

sub _process_update_for_type ($m, $task, $fields_to_update) {
  $m->app->model('challenge-task-days')->process_update($task->{id}, $fields_to_update)
    if $task->{type} eq 'days';
}

sub _process_list_for_type ($m, $task) {
  $task->{days} = $m->app->model('challenge-task-days')->list($task->{id})
    if $task->{type} eq 'days';
}

1
