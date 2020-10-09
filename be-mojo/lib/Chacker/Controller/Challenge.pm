package Chacker::Controller::Challenge;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::Collection 'c';

has challenges => sub { state $challenges = shift->schema->resultset('Challenge') };

sub list ($c) {
  my @challenges = $c->challenges->all;
  my @ch_h;
  for my $ch (@challenges) {
    my %ch_h = $ch->get_columns;
    my @tasks_h;
    for my $task ($ch->tasks) {
      push @tasks_h, {$task->get_columns}
    }
    $ch_h{tasks} = \@tasks_h;

    push @ch_h, \%ch_h
  }
  return $c->api->cool(\@ch_h);
}

sub add ($c) {
  my $challenge = $c->req->json;
  #TODO security check
  my $inserted = $c->challenges->create($challenge);
  return $c->api->cool({id => $inserted->id });
}

1;
