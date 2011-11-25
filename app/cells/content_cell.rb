class ContentCell < Cell::Rails
  
  extend ActiveSupport::Memoizable
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  include Devise::Controllers::Helpers
  helper_method :current_user
  
  def text_widget(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    render
  end
  
  def rich_text_widget(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    render
  end
  
  def articles_list(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])    
    @articles = Article.published.where("lang = ?", get_lang).includes(:categorizations)
    @articles = @articles.not_reserved unless (args[:current_user] && args[:current_user].is_privileged?)
    @articles = @articles.where("categorizations.category_id IN (?)", args[:options][:categories]) if (args[:options] && args[:options][:categories])
    render
  end
  
  def twitter_stream(args)
    fill_generic_variables(args[:page], args[:options], args[:snip_id])
    render
  end
  
  # def download_widget(args)
  #   @options = args[:options]
  #   @snip_id = args[:snip_id]
  #   render
  # end
  
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
