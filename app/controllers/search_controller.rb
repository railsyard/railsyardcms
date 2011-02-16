class SearchController < ApplicationController
  
  layout :set_layout
  before_filter [:set_default_variables]
  
  def index
    @cfg = cfg
    @articles = []
    @snippets = []
    
    @query = params[:search]
    src = "%#{@query}%"
    
    if !src.blank? && current_user && current_user.is_privileged?
      @articles = Article.find(:all,
                               :order => "created_at DESC",
                               :conditions => ["title LIKE ? OR short LIKE ? OR body LIKE ?", src, src, src],
                               :limit => 20)
      @snippets = EditableContentSnippet.find(:all,
                                              :order => "created_at DESC",
                                              :conditions => ["name LIKE ? OR body LIKE ?", src, src],
                                              :limit => 20)
    elsif !src.blank?
      @articles = Article.find(:all,
                               :order => "created_at DESC",
                               :conditions => ["title LIKE ? OR short LIKE ? OR body LIKE ?", src, src, src],
                               :limit => 20)
      @snippets = EditableContentSnippet.find(:all,
                                              :order => "created_at DESC",
                                              :joins => "INNER JOIN associations ON associations.snippet_id = snippets.id INNER JOIN pages on associations.page_id = pages.id",
                                              :conditions => ["pages.reserved = false AND (snippets.name LIKE ? OR snippets.body LIKE ?)", src, src],
                                              :limit => 20)
    end
  end  
  
  private
  
  def set_layout
    Layout.find(@cfg.theme_name, 'signup').path
  end
  
  def set_default_variables
    @cfg = cfg
    @hp = yard_home
    @meta_title = "Signup - #{@cfg.site_name} #{@cfg.site_page_title}"
    @meta_desc = "Signup - #{@cfg.site_desc}"
    @meta_keyword = "#{@cfg.site_keyword}"
    @first_level_pages = @hp.self_and_siblings.for_language(get_lang)  
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)