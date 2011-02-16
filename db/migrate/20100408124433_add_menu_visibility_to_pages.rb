class AddMenuVisibilityToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :visible_in_menu, :boolean, :default => 1
  end

  def self.down
    remove_column :pages, :visible_in_menu
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)