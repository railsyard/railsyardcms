class AddSnippetIdToCategorizations < ActiveRecord::Migration
  def self.up
    add_column :categorizations, :snippet_id, :integer
  end

  def self.down
    remove_column :categorizations, :snippet_id
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)