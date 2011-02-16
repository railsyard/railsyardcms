class AddThemeNameToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :theme_name, :string, :default => 'ry-default'
  end

  def self.down
    remove_column :settings, :theme_name
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)