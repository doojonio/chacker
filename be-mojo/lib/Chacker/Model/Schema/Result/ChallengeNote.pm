use utf8;

package Chacker::Model::Schema::Result::ChallengeNote;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("challenge_notes");
__PACKAGE__->add_columns(
  "id",
  {data_type => "integer", is_auto_increment => 1, is_nullable => 0, sequence => "challenge_notes_id_seq",},
  "challenge_id",
  {data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "note",
  {data_type => "varchar", is_nullable => 0, size => 500},
  "create_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => {default_value => \"now()"},
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "challenge",
  "Chacker::Model::Schema::Result::Challenge",
  {id            => "challenge_id"},
  {is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION"},
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-12-25 12:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UZ8AvXKaVwZYVDrXsTY4JQ

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
