class AddDivIdClassToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :div_id, :string
    add_column :snippets, :div_class, :string
    add_column :snippets, :div_style, :string
  end

  def self.down
    remove_column :snippets, :div_class
    remove_column :snippets, :div_id
    remove_column :snippets, :div_style
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)