class AddActContrToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :act, :string
    add_column :snippets, :contr, :string
    add_column :snippets, :additional_params, :text
  end

  def self.down
    remove_column :snippets, :additional_params
    remove_column :snippets, :contr
    remove_column :snippets, :act
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)