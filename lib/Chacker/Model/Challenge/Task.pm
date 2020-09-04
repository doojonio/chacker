package Chacker::Model::Challenge::Task;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_tasks     => 'tasks';
has f_tasks     => sub{c(qw'id challenge_id title type state')};
has task_types  => sub{c(qw'checklist days once')};
has task_states => sub{c(qw'completed in_progress new failed')};

sub add ($m, $challenge_id, $tasks) {
  my $choped_tasks = c;
  $tasks->each(sub{
    $_->{challenge_id} = $challenge_id;
    push @$choped_tasks, $m->app->chop($_, $m->f_tasks);
  });
  $choped_tasks->each(sub ($task, $num) {
    my $id = $m->app->db->insert($m->t_tasks, $task, { returning => 'id' })->hash->{id};
    $tasks->[--$num]->{id} = $id;
  });
  return $tasks;
}

1
