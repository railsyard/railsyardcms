class AddBodyToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :body, :text
  end

  def self.down
    remove_column :snippets, :body
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)