use utf8;
package Chacker::Model::Schema::Result::DayTaskRecord;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("day_task_records");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0, is_auto_increment => 1 },
  "task_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "day",
  { data_type => "date", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
  "task",
  "Chacker::Model::Schema::Result::Task",
  { id => "task_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

1
