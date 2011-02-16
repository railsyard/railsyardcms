class AddSeoToPages < ActiveRecord::Migration
  def self.up
    add_column    :pages, :meta_title,    :string
    add_column    :pages, :meta_keyword, :string
    add_column    :pages, :meta_desc,    :string
    add_column    :pages, :pretty_url,   :string
    add_column    :pages, :published,    :boolean, :default => false
    add_column    :pages, :publish_at,   :datetime
    change_column :pages, :description,  :text
    add_index     :pages, :pretty_url, :unique => true
  end

  def self.down
    remove_column :pages, :publish_at
    remove_column :pages, :published
    remove_column :pages, :pretty_url
    remove_column :pages, :meta_desc
    remove_column :pages, :meta_keyword
    remove_column :pages, :meta_title
    change_column :pages, :description, :string
    remove_index  :pages, :pretty_url
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)