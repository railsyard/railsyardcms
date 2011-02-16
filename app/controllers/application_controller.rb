class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  helper_method :get_yard_url, :yard_home, :yard_home_link, :cfg, :get_article_url, :get_lang # listed methods became helpers
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :set_locale 
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
  def cfg
    Setting.first
  end
  
  def yard_home
    Page.roots.find(:first, :order => "position ASC", :conditions => ["lang = ?", get_lang])
  end
  
  def yard_home_link
    get_yard_url(yard_home.id)
  end
  
  def get_yard_url(dest, options = {}) #generates cms urls  
    lang = options[:lang].blank? ? get_lang : options[:lang]   
    if dest.kind_of? String
      page = Page.find(:first, :conditions => ["pretty_url = ?", dest]) #find by Page's pretty url
    elsif dest.kind_of? Integer
      page = Page.find(dest) #find by Page's id
    elsif dest.class == Page
      page = Page.find(dest.id)
    end
    
    if page
      yard_url = "/#{lang}" 
      page.ancestors.reverse.each{|a| yard_url += "/#{a.pretty_url}"}
      yard_url += "/#{page.pretty_url}"
    else
      "/"
    end  
  end
  
  def get_lang
    req = request.request_uri
    #curr_lang = req.scan(/\/(.*?)\//).flatten.first
    curr_lang = req.split('/')[1]  
    if !curr_lang.blank? && curr_lang.length == 2 && curr_lang =~ /en|it/
      lang = curr_lang
    else
      lang = cfg.default_lang
    end
    lang
  end
  
  def admin_area?
    req = request.request_uri
    req.split('/')[1] == 'admin'
  end
  
  def set_locale
    if admin_area? && current_user
      I18n.locale = current_user.lang
    else
      I18n.locale = get_lang
    end
  end
  
  def get_article_url(article)
    show_article_path(article.lang, article.publish_at.year, article.publish_at.month, article.publish_at.day, article.pretty_url)
  end
  
  def rescue_action_in_public(exception)
    logger.error("rescue_action_in_public executed")
  	case exception
  	when ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownAction
  	  logger.error("404 displayed")
  		render(:file	=> "#{RAILS_ROOT}/public/404.html",	:status	=> "404 Not Found")
  	else
  		logger.error("500 displayed")
  		render(:file	=> "#{RAILS_ROOT}/public/500.html",	:status	=> "500 Error")
  		#SystemNotifier.deliver_exception_notification(self, request, exception)
  	end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)