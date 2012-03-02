class ApplicationController < ActionController::Base
  include Yard
  before_filter :get_configuration, :set_locale

  protect_from_forgery

  layout :layout_by_resource
  theme :get_theme

  # Enables CanCan site-wide - brokens Devise login - need to override Devise SessionsController
  # check_authorization

  helper :all # include all helpers, all the time
  helper_method :cfg, :yard_home, :get_lang, :get_yard_url, :get_article_url # coming from lib/yard - listed methods became helpers

  rescue_from CanCan::AccessDenied do |exception|
    render_error('401')
  end


  # Devise overrides to manage redirect after login
  before_filter :store_location

  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
  end

  def after_sign_in_path_for(resource)
    if resource.is_admin?
      admin_pages_path
    elsif resource.is_article_writer?
      admin_articles_path
    else
      stored_location_for(resource) || root_path
    end
  end
  # end Devise overrides


  private

  def get_configuration
    @cfg = cfg
  end

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

  def layout_by_resource
    if devise_controller?
      "admin_login"
    else
      "application"
    end
  end

end
