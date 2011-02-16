class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string    :title
      t.text      :short
      t.text      :body
      t.string    :meta_title
      t.string    :meta_keyword
      t.string    :meta_desc
      t.string    :pretty_url
      t.boolean   :published, :default => false
      t.datetime  :publish_at
      t.timestamps
    end
    add_index :articles, :pretty_url, :unique => true
  end

  def self.down
    drop_table    :articles
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)