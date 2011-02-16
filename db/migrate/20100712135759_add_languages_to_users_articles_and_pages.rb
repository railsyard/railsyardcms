class AddLanguagesToUsersArticlesAndPages < ActiveRecord::Migration
  def self.up
    add_column :users, :lang, :string, :default => 'en'
    add_column :articles, :lang, :string, :default => 'en'
    add_column :pages, :lang, :string, :default => 'en'
  end

  def self.down
    remove_column :users, :lang
    remove_column :pages, :lang
    remove_column :articles, :lang
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)