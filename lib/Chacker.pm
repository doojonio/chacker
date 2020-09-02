package Chacker;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Pg;

sub startup ($app) {
  $app->setup_plugins;
  $app->setup_webidentity;
  $app->setup_db;
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
  $app->helper(pg => sub{ state $pg = Mojo::Pg->new($app->config->{database}) });
  $app->helper(db => sub{ $app->pg->db });
  $app->pg->migrations->from_file($app->home.'/etc/migrations.sql')->migrate;
}

sub setup_routes($app) {
  my $r = $app->routes;
}

1;
