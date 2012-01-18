class RenameAssociationsToPastes < ActiveRecord::Migration
  def up
    rename_table :associations, :pastes
  end

  def down
    rename_table :pastes, :associations
  end
end
