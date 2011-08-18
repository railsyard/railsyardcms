class ContentCell < Cell::Rails
  include Yard
  
  def text_widget(args)
    @options = args[:options]
    render
  end
  
  def rich_text_widget(args)
    @options = args[:options]
    render
  end
  
  def twitter_stream(args)
    @options = args[:options]
    render
  end
  
  def articles_list(args)
    @articles = Article.published.not_reserved.all
    render
  end
  
  
  def download_widget(args)
    @options = args[:options]
    render
  end
  
  
end
