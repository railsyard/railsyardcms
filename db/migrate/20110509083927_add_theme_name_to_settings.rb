class AddThemeNameToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :theme_name, :string, :default => 'rough', :null => false
  end
  
  def self.down
    remove_column :settings, :theme_name
  end
end
