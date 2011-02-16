# Author::    Silvio Relli  (mailto:silvio@relli.org)

class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      
      # Needed by acts_as_category
      t.integer :parent_id, :children_count, :ancestors_count, :descendants_count
      t.boolean :hidden

      # Optional
      t.string :name, :description
      t.integer :position
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
