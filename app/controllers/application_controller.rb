class ApplicationController < ActionController::Base
  include Yard
  extend ActiveSupport::Memoizable
  before_filter :get_configuration, :set_locale
  
  protect_from_forgery
  
  theme :get_theme
  
  # Enables CanCan site-wide - brokens Devise login - need to override Devise SessionsController
  # check_authorization
  
  helper :all # include all helpers, all the time
  helper_method :cfg, :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard - listed methods became helpers
  
  rescue_from CanCan::AccessDenied do |exception|
    render_error('401')
  end
      
  private
  
  def get_configuration
    @cfg = cfg
  end
  memoize :get_configuration
  
  def admin_area?
    req = request.fullpath
    req.split('/')[1] == 'admin'
  end
  
  def set_locale
    if admin_area? && current_user
      I18n.locale = current_user.lang
    else
      I18n.locale = get_lang
    end
  end
  
  def get_theme
    cfg.theme_name
  end

  def render_error(type='500')
    logger.error("============================= Error #{type} displayed =============================")
    case type
      when "404" then render(:layout => false, :file	=> "#{Rails.root.to_s}/public/404.html", :status	=> "404 Not Found")
      when "401" then render(:layout => false, :file	=> "#{Rails.root.to_s}/public/401.html", :status	=> "401 Unauthorized")
      when "500" then render(:layout => false, :file	=> "#{Rails.root.to_s}/public/500.html", :status	=> "500 Internal Server Error")
    end
  end
  
  # def rescue_action_in_public(exception)
  #   logger.error("rescue_action_in_public executed")
  #   case exception
  #   when ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownAction
  #     logger.error("404 displayed")
  #     render(:file  => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found")
  #   else
  #     logger.error("500 displayed")
  #     render(:file  => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
  #     #SystemNotifier.deliver_exception_notification(self, request, exception)
  #   end
  # end
  
end
