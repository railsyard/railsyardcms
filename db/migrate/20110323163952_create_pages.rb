class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title, :string
      t.column :pretty_url, :string
      t.column :ancestry, :string
      t.column :position, :integer
      t.column :published, :boolean
      t.column :publish_at, :datetime
      t.column :lang, :string
      t.column :visible_in_menu, :boolean
      t.column :meta_title, :string
      t.column :meta_description, :string
      t.column :meta_keywords, :string
      t.column :script, :text
      t.column :div_id, :string
      t.column :div_class, :string
      t.column :div_style, :string
      t.column :reserved, :boolean
      t.column :layout_name, :string
      t.timestamps
    end
    
    add_index :pages, :title
    add_index :pages, :pretty_url
    add_index :pages, :ancestry
  end

  def self.down
    drop_table :pages
  end
end
