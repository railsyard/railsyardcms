class CreateArticleLayouts < ActiveRecord::Migration
  def self.up
    create_table :article_layouts do |t|
      t.column "layout_name", :string
      t.column "lang", :string
      t.timestamps
    end
    
    add_column :associations, :article_layout_id, :integer
    
    theme = Setting.first.theme_name
    first_layout = Layout.all(theme).first.filename
    
    ["it", "en", "de", "cn"].each do |lang|
      ArticleLayout.create(:layout_name => first_layout, :lang => lang )
    end
    
  end

  def self.down
    remove_column :associations, :article_layout_id
    drop_table :article_layouts
  end
end
