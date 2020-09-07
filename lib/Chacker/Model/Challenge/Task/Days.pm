package Chacker::Model::Challenge::Task::Days;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_days => 'day_task_records';
has f_days => sub{[qw'id task_id day']};

sub list ($m, $task_id) {
  $m->app->db->select($m->t_days, $m->f_days, {task_id => $task_id})
    ->hashes->to_array;
}

sub process_update($m, $task_id, $fields_to_update) {
  my ($days2add, $days2remove) = $m->_extract_days($fields_to_update->{days});

  if (scalar(@$days2add) >= 1) {
    $m->app->db->insert($m->t_days, { task_id => $task_id, day => $_ })
      for @$days2add;
  }

  if (scalar(@$days2remove) >= 1) {
    $m->app->db->delete($m->t_days, { task_id => $task_id, day => $_ })
      for @$days2remove;
  }

  return $task_id;
}

sub check_for_update ($m, $fields_to_update) {
  my @res = eval { $m->_extract_days($fields_to_update->{days}) };

  return scalar(@res);
}

sub _extract_days ($m, $h_days) {
  my $days2add = $h_days->{add} // [];
  my $days2remove = $h_days->{remove} // [];

  die 'no days found' if ( scalar(@$days2add) < 1 && scalar(@$days2remove) < 1 );

  return ($days2add, $days2remove);
}

1
