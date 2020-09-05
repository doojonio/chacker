package Chacker::Model::Challenge::Task;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_tasks     => 'tasks';
has f_tasks     => sub{[qw'id challenge_id title type state']};
has task_types  => sub{[qw'checklist days once']};
has task_states => sub{[qw'completed in_progress new failed']};

sub list ($m, $challenge_id) {
  my $tasks = $m->app->db->select($m->t_tasks, $m->f_tasks, { challenge_id => $challenge_id })
    ->hashes->each(sub {$m->_process_list_for_type($_)});
  return $tasks->to_array;
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

sub _process_list_for_type ($m, $task) {
  $task->{days} = $m->app->model('challenge-task-days')->list($task->{id})
    if $task->{type} eq 'days';
}

1
