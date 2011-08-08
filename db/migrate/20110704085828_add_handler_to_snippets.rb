class AddHandlerToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :handler, :string
  end

  def self.down
    remove_column :snippets, :handler
  end
end
