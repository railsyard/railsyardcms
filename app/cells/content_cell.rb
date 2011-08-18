class ContentCell < Cell::Rails
  include Yard
  
  def text_widget(args)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  def rich_text_widget(args)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  def twitter_stream(args)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  def articles_list(args)
    @articles = Article.published.not_reserved.all
    @snip_id = args[:snip_id]
    render
  end
  
  
  def download_widget(args)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  
end
