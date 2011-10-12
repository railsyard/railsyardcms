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
    
    first_theme = Theme.all.first.short
    first_layout = Layout.all(first_theme).first.filename
    
    ["it", "en"].each do |lang|
      puts "------------------------- Creating root language page \'#{lang}\' -------------------------"
      root = Page.create :title => lang, :pretty_url => lang, :lang => lang
      root.children.create :title => "Home #{lang}",
                           :pretty_url => "home_#{lang}",
                           :lang => lang,
                           :visible_in_menu => true,
                           :reserved => false,
                           :published => true,
                           :layout_name => first_layout,
                           :publish_at => Time.now,
                           :meta_title => "Home #{lang}",
                           :meta_description => "Home #{lang}"

    end

  end

  def self.down
    drop_table :pages
  end
end
