package Chacker::Model::Challenge::Task::Checklist;

use Mojo::Base 'MojoX::Model', -signatures;
use Mojo::Collection 'c';

has t_checklist => 'checklist_task_items';
has f_checklist => sub{c(qw'id task_id title checked')};

sub add ($m, $task_id, $items) {
  $items->each(sub {
    my $choped_item = $m->app->chop($_, $m->f_checklist);
    $choped_item->{task_id}   = $task_id;
    $choped_item->{checked} //= 'false';
    $m->app->db->insert($m->t_checklist, $choped_item);
  });
}

1;
