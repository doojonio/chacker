use utf8;

package Chacker::Model::Schema::Result::Challenge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("challenges");
__PACKAGE__->add_columns(
  "id",
  {data_type => "integer", is_auto_increment => 1, is_nullable => 0, sequence => "challenges_id_seq",},
  "title",
  {data_type => "varchar", is_nullable => 0, size => 100},
  "description",
  {data_type => "varchar", is_nullable => 0, size => 300},
  "state",
  {
    data_type   => "enum",
    extra       => {custom_type_name => "challenge_state", list => ["completed", "in progress", "new", "failed"],},
    is_nullable => 0,
  },
  "picture",
  {data_type => "integer", is_foreign_key => 1, is_nullable => 1},
  "create_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => {default_value => \"now()"},
  },
  "change_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => {default_value => \"now()"},
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "challenge_notes",
  "Chacker::Model::Schema::Result::ChallengeNote",
  {"foreign.challenge_id" => "self.id"},
  {cascade_copy           => 0, cascade_delete => 0},
);
__PACKAGE__->belongs_to(
  "picture",
  "Chacker::Model::Schema::Result::Image",
  {id            => "picture"},
  {is_deferrable => 0, join_type => "LEFT", on_delete => "NO ACTION", on_update => "NO ACTION",},
);
__PACKAGE__->has_many(
  "tasks",
  "Chacker::Model::Schema::Result::Task",
  {"foreign.challenge_id" => "self.id"},
  {cascade_copy           => 0, cascade_delete => 0},
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-12-25 12:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HWocoB3lg2KoWePJ+sBGHA

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
