class ArticleCell < Cell::Rails
  
  extend ActiveSupport::Memoizable
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  include Devise::Controllers::Helpers
  helper_method :current_user
  
  def article_show(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    @article = args[:article]
    render
  end
  
  def comments(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    @article = args[:article]
    #@comments = @article.comments
    render
  end
  
  private
  
  def fill_generic_variables(page, options, snip_id)
    @page = page ||= yard_home
    @options = options ||= {}
    @snip_id = snip_id
    @cfg = cfg
    @current_user = current_user
  end

  def cfg
    Setting.first
  end
  memoize :cfg
  
end
