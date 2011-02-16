class GenerateHomepage < ActiveRecord::Migration
  def self.up
    #removing default lang value
    change_column :pages, :lang, :string
    
    #create homepage only if no other page already present
    firstpage = Page.first
    if firstpage.blank?
      hp = Page.create :name => "Homepage", :pretty_url => "homepage", :user_id => 1, :published => 1, :visible_in_menu => 1, :lang => "en"
      pp = Page.create :name => "Prima pagina", :pretty_url => "prima-pagina", :user_id => 1, :published => 1, :visible_in_menu => 1, :lang => "it"
    end
  end

  def self.down
    change_column :pages, :lang, :string, :default => "en"
    hp = Page.find(:first, :conditions => [ "pretty_url = ?", "homepage"])
    hp.destroy unless hp.nil?
    pp = Page.find(:first, :conditions => [ "pretty_url = ?", "prima-pagina"])
    pp.destroy unless pp.nil?
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)