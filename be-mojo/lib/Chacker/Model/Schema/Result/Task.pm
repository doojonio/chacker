use utf8;
package Chacker::Model::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Chacker::Model::Schema::Result::Task

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tasks>

=cut

__PACKAGE__->table("tasks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 challenge_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 type

  data_type: 'enum'
  extra: {custom_type_name => "task_type",list => ["days","once"]}
  is_nullable: 0

=head2 state

  data_type: 'enum'
  extra: {custom_type_name => "task_state",list => ["completed","in progress","new","failed"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
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

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 challenge

Type: belongs_to

Related object: L<Chacker::Model::Schema::Result::Challenge>

=cut

__PACKAGE__->belongs_to(
  "challenge",
  "Chacker::Model::Schema::Result::Challenge",
  { id => "challenge_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 day_task_records

Type: has_many

Related object: L<Chacker::Model::Schema::Result::DayTaskRecord>

=cut

__PACKAGE__->has_many(
  "day_task_records",
  "Chacker::Model::Schema::Result::DayTaskRecord",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-09-21 19:55:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xdMHqbLSyM19ug8xaAWT0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
