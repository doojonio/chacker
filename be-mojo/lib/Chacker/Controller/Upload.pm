package Chacker::Controller::Upload;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::File qw(path);
use Digest::MD5 qw(md5_hex);

has images  => sub { state $images  = shift->schema->resultset('Image') };
has save_to => sub { state $save_to = shift->app->config->{uploads}{save_to} };

sub image ($c) {
  my $image = $c->param('image');

  #TODO sanitizing filename
  my $file_ext      = Mojo::File->new($image->filename)->extname;
  my $save_filename = md5_hex($image->slurp) . ".$file_ext";
  $save_filename =~ s/^(\w{4})(\w{4})/$1\/$2\//;
  path($c->save_to, "$1/$2/")->make_path;

  $image->move_to(path($c->save_to, $save_filename));

  my $inserted = $c->images->create({name => $image->filename, path => $save_filename,});

  return $c->api->cool({$inserted->get_columns});
}

1;
