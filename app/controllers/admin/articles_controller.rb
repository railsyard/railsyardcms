class Admin::ArticlesController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_roles(["admin", "article_writer"])
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def index
    @categories = Category.all
    @articles = Article.all
    @admin_editing_language = admin_editing_language
  end
  
  def new
    @categories = Category.all
    @article = current_user.articles.new
    @admin_editing_language = admin_editing_language
  end
  
  def create
    @categories = Category.all
    @article = current_user.articles.new(params[:article])
    @article.pretty_url = @article.pretty_url.urlify.blank? ? @article.title.urlify : @article.pretty_url.urlify
    @article.publish_at = Time.now if @article.published
    
    # # can't get working nested_attributes with mas_many through (maybe rails 2.3.8 bug?), making manual associations:
    # unless params[:categories].blank?
    #   params[:categories].map do |cat|
    #     @article.categories << @categories.select {|c| c.id == cat.to_i}
    #   end
    # end
    
    if @article && @article.save && @article.errors.empty?
      # if params[:commit_type] == 'save'
      #   render :action => "edit"
      # elsif params[:commit_type] == 'save_and_close'
      #   redirect_to admin_articles_path()
      # end
      redirect_to admin_articles_path
    else
      render :action => "new"
    end
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.attributes = params[:article] unless @article.blank?
    if @article && @article.save && @article.errors.empty?
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end
  end
  
end