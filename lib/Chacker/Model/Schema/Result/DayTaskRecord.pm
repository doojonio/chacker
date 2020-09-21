use utf8;
package Chacker::Model::Schema::Result::DayTaskRecord;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Chacker::Model::Schema::Result::DayTaskRecord

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<day_task_records>

=cut

__PACKAGE__->table("day_task_records");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 task_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 day

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "task_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "day",
  { data_type => "date", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 task

Type: belongs_to

Related object: L<Chacker::Model::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
  "task",
  "Chacker::Model::Schema::Result::Task",
  { id => "task_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-09-21 19:55:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vu+2bBXKuyo5RC5VloWTeg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
