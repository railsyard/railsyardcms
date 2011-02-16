class AddGoToFirstChildToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :go_to_first_child, :boolean
  end

  def self.down
    remove_column :snippets, :go_to_first_child
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)