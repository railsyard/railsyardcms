class CreateArticleLayouts < ActiveRecord::Migration
  def self.up
    create_table :article_layouts do |t|
      t.column "layout_name", :string
      t.column "lang", :string
      t.timestamps
    end
    
    add_column :associations, :article_layout_id, :integer
  end

  def self.down
    remove_column :associations, :article_layout_id
    drop_table :article_layouts
  end
end
