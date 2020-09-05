package Chacker::Model::Challenge::Task::Days;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_days => 'day_task_records';
has f_days => sub{[qw'id task_id day']};

sub list ($m, $task_id) {
  $m->app->db->select($m->t_days, $m->f_days, {task_id => $task_id})
    ->hashes->to_array;
}

1
