package Chacker;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Pg;

sub startup ($app) {
  $app->setup_plugins;
  $app->setup_webidentity;
  $app->setup_db;
  $app->setup_helpers;
  $app->setup_routes;
}

sub setup_plugins ($app) {
  $app->plugin('NotYAMLConfig');
  $app->plugin('Model');
}

sub setup_webidentity ($app) {
  $app->secrets($app->config->{secrets});
}

sub setup_db ($app) {
  $app->helper(pg => sub { state $pg = Mojo::Pg->new($app->config->{database}) });
  $app->helper(db => sub { $app->pg->db });
  $app->pg->migrations->from_file($app->home . '/etc/migrations.sql')->migrate;
}

sub setup_routes($app) {
  my $r   = $app->routes;
  my $api = $r->any('/api');
  $api->post('/challenge')->to('challenge#add');
  $api->get('/challenge')->to('challenge#list');
  $api->put('/task/:id')->to('challenge-task#update');
}

sub setup_helpers ($app) {
  $app->helper(
    'api.cool' => sub ($c, %data) {
      $c->render(json => \%data, status => 200);
    }
  );
  $app->helper(
    'api.sad' => sub ($c, $reason) {
      $c->render(json => {error => $reason}, status => 400);
    }
  );

  $app->helper(
    'chop' => sub ($app, $hash, $fields) {
      my %choped;
      for (@$fields) {
        $choped{$_} = $hash->{$_} if $_ ne 'id';
      }
      return \%choped;
    }
  );
}

1;
