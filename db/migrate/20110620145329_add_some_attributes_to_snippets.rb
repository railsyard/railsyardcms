class AddSomeAttributesToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :cell_controller, :string
    add_column :snippets, :cell_action, :string
    add_column :snippets, :options, :text
    remove_column :snippets, :body
    remove_column :snippets, :settings
  end

  def self.down
    add_column :snippets, :settings, :text
    add_column :snippets, :body, :text
    remove_column :snippets, :options
    remove_column :snippets, :cell_action
    remove_column :snippets, :cell_controller
  end
end
