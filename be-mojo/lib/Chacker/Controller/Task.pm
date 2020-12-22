package Chacker::Controller::Task;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use DateTime;
use List::Util qw(any);
use Mojo::JSON qw(encode_json);

has tasks => sub { state $tasks = shift->schema->resultset('Task') };
has days  => sub { state $tasks = shift->schema->resultset('DayTaskRecord') };

sub get ($c) {
  my $task_id = $c->param('task_id');

  my $task = $c->tasks->find($task_id);

  unless ($task) {
    return $c->api->sad({error => "there is no task with id $task_id"});
  }

  my %response = $task->get_columns;
  if ($task->type eq 'days') {
    my @day_records = $task->day_task_records->all;
    my @days;
    for my $day_record (@day_records) {
      push @days, $day_record->day->ymd;
    }
    $response{days} = \@days;
  }

  return $c->api->cool(\%response);
}

sub update ($c) {
  my $task_id          = $c->param('task_id')      || return $c->api->sad({error => 'wrong id'});
  my $fields_to_update = $c->req->json             || return $c->api->sad({error => 'request body not found'});
  my $task             = $c->tasks->find($task_id) || return $c->api->sad({error => 'no task found'});

  $c->log->debug("Income JSON is:" . encode_json($fields_to_update));
  eval { $task->set_columns($fields_to_update) };
  return $c->api->sad({error => 'wrong data to update'}) if $@;
  $task->update;
  return $c->api->cool({$task->get_columns});
}

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
