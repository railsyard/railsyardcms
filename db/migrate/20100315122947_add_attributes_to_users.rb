class AddAttributesToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :name
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :role, :integer, :default => 3
    add_column :users, :enabled, :boolean, :default => false
    add_column :users, :last_login, :datetime
  end

  def self.down
    add_column :users, :name, :string
    remove_column :users, :firstname
    remove_column :users, :lastname
    remove_column :users, :role
    remove_column :users, :enabled
    remove_column :users, :last_login
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)