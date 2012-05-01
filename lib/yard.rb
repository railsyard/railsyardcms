module Yard
    
  private
  
  def cfg
    Setting.first
  end
  
  def yard_home(lang = cfg.default_lang)
    language = lang.nil? ? get_lang : lang
    Page.where(:lang => language, :ancestry => nil).first.children.order("position ASC").first 
  end
  
  def get_yard_url(dest) #generates cms urls
    if dest.kind_of? String
      page = Page.where(:pretty_url => dest).first
    elsif dest.kind_of? Integer
      page = Page.where(:id => dest).first
    elsif dest.class == Page
      page = Page.where(:id => dest.id).first
    end   
    if page
      yard_url = "" 
      Page.sort_by_ancestry(page.ancestors).map{|a| yard_url << "/#{a.pretty_url}"}
      yard_url << "/#{page.pretty_url}"
    else
      "/"
    end  
  end
  
  # Gets language from requested url if available,
  # otherwise uses the browser's user agent if included in available languages,
  # lastly uses the default language.
  def get_lang
    req = request.fullpath
    curr_lang = req.split('/').second
    if !curr_lang.blank? && curr_lang.length == 2 && curr_lang =~ $AVAILABLE_LANGUAGES
      lang = curr_lang
    else
      lang_tmp = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless (request.env.nil? || request.env['HTTP_ACCEPT_LANGUAGE'].blank?)
      lang = ((lang_tmp && lang_tmp =~ $AVAILABLE_LANGUAGES) ? lang_tmp : cfg.default_lang)
    end
    lang
  end
  
  def get_article_url(article, options={})
    show_article_path(article.lang, article.publish_at.year, article.publish_at.month, article.publish_at.day, article.pretty_url, options)
  end
  
end
