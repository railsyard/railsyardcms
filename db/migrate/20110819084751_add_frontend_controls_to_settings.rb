class AddFrontendControlsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :frontend_controls, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :frontend_controls
  end
end
