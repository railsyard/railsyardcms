class AddCssPropertiesToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :div_id, :string
    add_column :pages, :div_class, :string
    add_column :pages, :div_style, :string
  end

  def self.down
    remove_column :pages, :div_style
    remove_column :pages, :div_class
    remove_column :pages, :div_id
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)