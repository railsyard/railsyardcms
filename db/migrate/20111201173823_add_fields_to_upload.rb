class AddFieldsToUpload < ActiveRecord::Migration
  def self.up
    add_column :uploads, :title, :string
    add_column :uploads, :description, :text
    change_column :settings, :analytics, :text
  end

  def self.down
    change_column :settings, :analytics, :string
    remove_column :uploads, :description
    remove_column :uploads, :title
  end
end
