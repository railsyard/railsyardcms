class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.references :page
      t.references :snippet
      t.integer :position
      t.string :location
      t.timestamps
    end
  end

  def self.down
    drop_table :associations
  end
end
