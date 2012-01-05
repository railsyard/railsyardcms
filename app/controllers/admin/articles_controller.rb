class Admin::ArticlesController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_roles(["admin", "article_writer"])
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def index
    @admin_editing_language = admin_editing_language
    @categories = Category.all
    @articles = Article.where("lang = ?", @admin_editing_language)
  end
  
  def new
    @categories = Category.all
    @article = current_user.articles.new
    @admin_editing_language = admin_editing_language
    @article.meta_keywords = @cfg.default_page_keywords
    @article.meta_description = @cfg.default_page_desc
  end
  
  def create
    @article = current_user.articles.new(params[:article])
    @article.pretty_url = @article.pretty_url.urlify.blank? ? @article.title.urlify : @article.pretty_url.urlify
    @article.meta_title = @article.title if @article.meta_title.blank?
    #@article.meta_keywords = @cfg.default_page_keywords if @article.meta_keywords.blank?
    #@article.meta_description = @cfg.default_page_desc if @article.meta_keywords.blank?
    if @article && @article.save && @article.errors.empty?
      redirect_to admin_articles_path
    else
      render :action => "new"
    end
  end
  
  def edit
    @categories = Category.all
    @admin_editing_language = admin_editing_language
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.attributes = params[:article] unless @article.blank?
    @article.pretty_url = @article.pretty_url.urlify.blank? ? @article.title.urlify : @article.pretty_url.urlify
    @article.meta_title = @article.title if @article.meta_title.blank?
    #@article.meta_keywords = @cfg.default_page_keywords if @article.meta_keywords.blank?
    #@article.meta_description = @cfg.default_page_desc if @article.meta_keywords.blank?
    if @article && @article.save && @article.errors.empty?
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    if @article && @article.destroy && @article.errors.empty?
      redirect_to admin_articles_path
    end
  end
  
end