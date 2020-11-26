package Chacker::Controller::Task;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use List::Util qw(any);
use DateTime;

has tasks => sub { state $tasks = shift->schema->resultset('Task') };
has days  => sub { state $tasks = shift->schema->resultset('DayTaskRecord') };

sub record_day ($c) {
  my $task_id        = $c->param('task_id');
  my $days_to_record = $c->req->json('/days');

  my $task = $c->tasks->find($task_id);
  unless ($task) {
    return $c->api->sad({error => "there is no task with id $task_id",});
  }

  my @day_task_records = $task->day_task_records->all;
  for my $day (@$days_to_record) {
    my $day_of_year = eval { DateTime->new($c->_parse_date($day))->day_of_year } or return $c->api->sad({error => $@});
    if (any { $_->day->day_of_year eq $day_of_year } @day_task_records) {
      return $c->sad({error => "date $day already recorded"});
    }

    $c->days->create({task_id => $task->id, day => $day,});
  }

  return $c->api->cool($task->id);
}

sub _parse_date ($c, $date) {
  die "wrong date format: $date" unless $date =~ /(\d{4})-(\d\d)-(\d\d)/;

  return (year => $1, month => $2, day => $3,);
}

1
