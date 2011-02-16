class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.integer :page_id
      t.integer :snippet_id
      t.integer :position
      t.string :location
      t.timestamps
    end
  end

  def self.down
    drop_table :associations
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)