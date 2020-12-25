use utf8;

package Chacker::Model::Schema::Result::Image;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("images");
__PACKAGE__->add_columns(
  "id",
  {data_type => "integer", is_auto_increment => 1, is_nullable => 0, sequence => "images_id_seq",},
  "name",
  {data_type => "varchar", is_nullable => 0, size => 300},
  "path",
  {data_type => "text", is_nullable => 0},
  "upload_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => {default_value => \"now()"},
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "challenges", "Chacker::Model::Schema::Result::Challenge",
  {"foreign.picture" => "self.id"}, {cascade_copy => 0, cascade_delete => 0},
);
__PACKAGE__->has_many(
  "tasks",
  "Chacker::Model::Schema::Result::Task",
  {"foreign.picture" => "self.id"},
  {cascade_copy      => 0, cascade_delete => 0},
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-12-25 12:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OBBhtReoUHzoakxLl3xk+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
