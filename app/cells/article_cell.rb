class ArticleCell < Cell::Rails
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  include Devise::Controllers::Helpers
  helper_method :current_user
  include Cell::Filters
  before_filter :fill_generic_variables
  
  def article_show(args)
    @article = args[:article]
    render
  end
  
  def comments(args)
    @article = args[:article]    
    @comments = @article.comments.published.paginate(:page => params[:pagination])   
    render
  end
  
  private
  
  def fill_generic_variables(state, opts)
    @page = opts[:page] ||= yard_home
    @options = opts[:options] ||= {}
    @snip_id = opts[:snip_id]
    @cfg = cfg
    @current_user = opts[:current_user]
  end

  def cfg
    Setting.first
  end
  
end
