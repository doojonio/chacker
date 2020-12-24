use utf8;

package Chacker::Model::Schema::Result::TaskNote;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("task_notes");
__PACKAGE__->add_columns(
  "id",      {data_type => "integer", is_auto_increment => 1, is_nullable => 0, sequence => "task_notes_id_seq",},
  "task_id", {data_type => "integer", is_foreign_key    => 1, is_nullable => 0},
  "note",    {data_type => "varchar", is_nullable       => 0, size        => 500},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "task",
  "Chacker::Model::Schema::Result::Task",
  {id            => "task_id"},
  {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-12-24 10:42:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nv16w2kOq9E9SWcj1fFYBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
