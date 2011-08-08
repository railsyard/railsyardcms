class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string    :title
      t.text      :description
      t.text      :body
      t.text      :settings
      t.boolean   :deleted
      t.boolean   :published
      t.datetime  :publish_at
      t.string    :div_id
      t.string    :div_class
      t.string    :div_style
      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
