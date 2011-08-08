class AddSomeAttributesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :lang, :string
    add_column :users, :enabled, :boolean
  end

  def self.down
    remove_column :users, :enabled
    remove_column :users, :lang
  end
end
