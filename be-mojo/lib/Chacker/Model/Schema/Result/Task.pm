use utf8;
package Chacker::Model::Schema::Result::Task;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("tasks");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0, is_auto_increment => 1 },
  "challenge_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "type",
  {
    data_type => "enum",
    extra => { custom_type_name => "task_type", list => ["days", "once"] },
    is_nullable => 0,
  },
  "state",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "task_state",
      list => ["completed", "in progress", "new", "failed"],
    },
    is_nullable => 0,
  },
);

__PACKAGE__->belongs_to(
  "challenge",
  "Chacker::Model::Schema::Result::Challenge",
  { id => "challenge_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

__PACKAGE__->has_many(
  "day_task_records",
  "Chacker::Model::Schema::Result::DayTaskRecord",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
