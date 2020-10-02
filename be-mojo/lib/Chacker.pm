package Chacker;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Pg;

use Chacker::Model::Schema;

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
  my $dbconf = $app->config->{db};
  $app->helper(pg => sub { state $pg = Mojo::Pg->new($dbconf->{url}) });
  $app->helper(db => sub { $app->pg->db });
  $app->pg->migrations->from_file($app->home . '/etc/migrations.sql')->migrate;

  $app->helper(
    schema => sub {
      state $schema = Chacker::Model::Schema->connect(
        $dbconf->{dsn},
        $dbconf->{user},
        $dbconf->{pw},
      )
    }
  );
}

sub setup_routes($app) {
  my $api = $app->create_api_route('/api');

  $api->post('/challenge')->to('challenge#add');
  $api->get('/challenge')->to('challenge#list');
  $api->put('/challenge/:id')->to('challenge#update');

  $api->put('/task/:id')->to('challenge-task#update');
}

sub setup_helpers ($app) {
  $app->helper(
    'api.cool' => sub ($c, $data) {
      $c->render(json => $data, status => 200);
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
