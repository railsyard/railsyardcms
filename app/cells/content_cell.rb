class ContentCell < Cell::Rails
  include Yard
  helper_method :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard
  
  def text_widget(args)
    @options = args[:options] ||= {}
    @snip_id = args[:snip_id]
    render
  end
  
  def rich_text_widget(args)
    @options = args[:options] ||= {}
    @snip_id = args[:snip_id]
    render
  end
  
  def twitter_stream(args)
    @options = args[:options] ||= {}
    @snip_id = args[:snip_id]
    render
  end
  
  def articles_list(args)
    @articles = Article.published.not_reserved.all
    @snip_id = args[:snip_id]
    render
  end
  
  def article_show(args)
    @article = args[:article]
    @snip_id = args[:snip_id]
    render
  end
  
  # def download_widget(args)
  #   @options = args[:options]
  #   @snip_id = args[:snip_id]
  #   render
  # end
  
  
end
