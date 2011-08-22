class AddGermanLanguage < ActiveRecord::Migration
  def self.up
    lang = 'de'
    first_theme = Theme.all.first.short
    first_layout = Layout.all(first_theme).first.filename
    root = Page.create :title => lang, :pretty_url => lang, :lang => lang
    root.children.create :title => "Home #{lang}", :pretty_url => "home_#{lang}", :lang => lang, :visible_in_menu => true, :reserved => false, :published => true, :position => 1, :layout_name => first_layout, :publish_at => Time.now, :meta_title => "Home #{lang}", :meta_description => "Home #{lang}"
  end

  def self.down
    german_pages = Page.where("lang = ?", "de")
    german_pages.map{|p| p.destroy}
  end
end
