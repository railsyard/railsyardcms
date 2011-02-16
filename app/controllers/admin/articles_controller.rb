class Admin::ArticlesController < Admin::AdminController
  
  def index
    @categories = Category.all
    @articles = Article.paginate  :all,
                                  :order => "updated_at DESC",
                                  :page => params[:pagination]
  end
  
  def new
    @categories = Category.all
    @article = current_user.articles.new
  end
  
  def create
    @categories = Category.all
    @article = current_user.articles.new(params[:article])
    @article.pretty_url = @article.pretty_url.urlify.blank? ? @article.title.urlify : @article.pretty_url.urlify
    @article.publish_at = Time.now if @article.published
    
    # can't get working nested_attributes with mas_many through (maybe rails 2.3.8 bug?), making manual associations:
    unless params[:categories].blank?
      params[:categories].map do |cat|
        @article.categories << @categories.select {|c| c.id == cat.to_i}
      end
    end
    
    if @article && @article.save && @article.errors.empty?
      if params[:commit_type] == 'save'
        render :action => "edit"
      elsif params[:commit_type] == 'save_and_close'
        redirect_to admin_articles_path()
      end
    else
      render :action => "new"
    end
  end  
  
  def edit
    @categories = Category.all
    @article = Article.find(params[:id])
  end
  
  def update
    @categories = Category.all
    @article = Article.find(params[:id])
    if @article
      @article.update_attributes(params[:article])
      pretty_url = @article.pretty_url.urlify.blank? ? @article.title.urlify : @article.pretty_url.urlify
      @article.update_attributes(:pretty_url => pretty_url)
      @article.update_attributes(:publish_at => Time.now) if @article.published
      
      unless params[:categories].blank?
        @article.categorizations.each {|categorization| categorization.destroy}
        params[:categories].map do |cat|
          @article.categories << @categories.select {|c| c.id == cat.to_i}
        end
      end
      
      if @article.save && @article.errors.empty?
        if params[:commit_type] == 'save'
          render :action => "edit"
        elsif params[:commit_type] == 'save_and_close'
          redirect_to admin_articles_path()
        end
      else
        render :action => "edit"
      end
    end
  end

  def destroy
    Article.find(params[:id]).update_attributes!(:deleted => true)
    redirect_to admin_articles_path()
  end
  
  def toggle
    art = Article.find(params[:id])
    if art
      art.toggle
      render :update do |page|
        page.replace "article-#{art.id}", :partial => 'admin/articles/item', :object => art
      end
    else
      logger.error "Admin article toggle error"
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)