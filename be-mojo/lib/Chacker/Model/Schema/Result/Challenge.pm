use utf8;
package Chacker::Model::Schema::Result::Challenge;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("challenges");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0, is_auto_increment => 1 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 150 },
  "state",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "challenge_state",
      list => ["completed", "in progress", "new", "failed"],
    },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "tasks",
  "Chacker::Model::Schema::Result::Task",
  { "foreign.challenge_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
