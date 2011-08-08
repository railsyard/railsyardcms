class MovingSnippetLocation < ActiveRecord::Migration
  def self.up
    add_column :snippets, :area, :string
    remove_column :associations, :location
  end

  def self.down
    add_column :associations, :location, :string
    remove_column :snippets, :area
  end
end
