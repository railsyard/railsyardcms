class Admin::AdminController < ApplicationController
  layout :set_layout
  
  before_filter :authenticate_user!, :except => [:login, :logout]
  
  ## old auth method in admin controller
  #before_filter [:check_authentication], :except => [:login, :logout]
  
  # check authorization with cancan in the backend
  check_authorization
  
  protected
  
  def set_layout
    case action_name.to_s
    when "login"
      "admin_login"
    else
      "admin"
    end
  end
  
  def check_role(role)
    render_error('401') unless current_user && current_user.role?(role) && current_user.enabled
  end
  
  def check_roles(roles_array)
    render_error('401') unless current_user && current_user.roles?(roles_array) && current_user.enabled
  end
  
  def admin_editing_language
    session[:admin_editing_language].blank? ? cfg.default_lang : session[:admin_editing_language]
  end
  
end
