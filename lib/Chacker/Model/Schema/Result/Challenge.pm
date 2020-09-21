use utf8;
package Chacker::Model::Schema::Result::Challenge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Chacker::Model::Schema::Result::Challenge

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<challenges>

=cut

__PACKAGE__->table("challenges");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 150

=head2 state

  data_type: 'enum'
  extra: {custom_type_name => "challenge_state",list => ["completed","in progress","new","failed"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
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

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 tasks

Type: has_many

Related object: L<Chacker::Model::Schema::Result::Task>

=cut

__PACKAGE__->has_many(
  "tasks",
  "Chacker::Model::Schema::Result::Task",
  { "foreign.challenge_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-09-21 19:55:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:blEOPBpnjHpQaB3WTbx3Lw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
