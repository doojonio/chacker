package Chacker;
use Mojo::Base 'Mojolicious', -signatures;

use Chacker::Model::Schema;
use GraphQL::Plugin::Convert::DBIC;
use Mojo::File qw(path);
use Mojo::Pg;

sub startup ($app) {
  $app->plugin('NotYAMLConfig');

  $app->setup_webidentity;
  $app->setup_db;
  $app->setup_helpers;
  $app->setup_routes;
}

sub setup_webidentity ($app) {
  $app->secrets($app->config->{secrets});
}

sub setup_db ($app) {
  my $dbconf = $app->config->{db};
  $app->helper(pg => sub { state $pg = Mojo::Pg->new($dbconf->{url}) });
  $app->helper(db => sub { $app->pg->db });
  $app->pg->migrations->from_file($app->home . '/etc/migrations.sql')->migrate;

  $app->helper(
    schema => sub {
      state $schema = Chacker::Model::Schema->connect($dbconf->{dsn}, $dbconf->{user}, $dbconf->{pw},);
    }
  );
}

sub setup_routes($app) {
  my $api = $app->create_api_route('/api');
  $api->post('/challenge')->to('challenge#add');
  $api->get('/challenge')->to('challenge#list');
  $api->get('/task/:task_id')->to('task#get');
  $api->post('/task/:task_id/record')->to('task#record_day');

  if ($app->mode eq 'development') {
    path($app->home, 'etc', 'graphql_doc.txt')
      ->spurt(GraphQL::Plugin::Convert::DBIC->to_graphql($app->schema)->{schema}->to_doc);
  }

  $app->plugin('GraphQL', {convert => ['DBIC', $app->schema], endpoint => '/api/graphql',});
}

sub setup_helpers ($app) {
  $app->helper(
    'api.cool' => sub ($c, $data) {
      $c->render(json => $data, status => 200);
    }
  );
  $app->helper(
    'api.sad' => sub ($c, $data) {
      $c->render(json => $data, status => 400);
    }
  );
}

sub create_api_route ($app, $url) {
  my $api = $app->routes->under(
    $url => sub ($c) {
      my $headers = $c->res->headers;
      $headers->header('Access-Control-Allow-Origin'      => '*');
      $headers->header('Access-Control-Allow-Credentials' => 'true');
      $headers->header('Access-Control-Allow-Methods'     => 'GET, OPTIONS, POST, DELETE, PUT');
      $headers->header('Access-Control-Allow-Headers'     => 'Content-Type');
      $headers->header('Access-Control-Max-Age'           => '1728000');
    }
  );
  $api->options('*')->to(cb => sub ($c) { $c->render(data => '') });

  return $api;
}

1;
