class Admin::SearchController < Admin::AdminController
  
  def index
    @articles = []
    @snippets = []
    
    @query = params[:search]
    src = "%#{@query}%"
    
    if !src.blank?
      @articles = Article.find(:all,
                               :order => "created_at DESC",
                               :conditions => ["title LIKE ? OR short LIKE ? OR body LIKE ?", src, src, src],
                               :limit => 20)
      @snippets = EditableContentSnippet.find(:all,
                                              :order => "created_at DESC",
                                              :conditions => ["name LIKE ? OR body LIKE ?", src, src],
                                              :limit => 20)
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)