class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :short
      t.text :body
      t.string :meta_title
      t.string :meta_keyword
      t.string :meta_desc
      t.string :pretty_url
      t.boolean :published
      t.datetime :publish_at
      t.integer :user_id
      t.text :script
      t.string :lang
      t.boolean :reserved
      t.boolean :comments_enabled
      t.boolean :hot
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
