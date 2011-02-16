class Admin::AdminController < ApplicationController
  layout :set_layout
  
  helper_method :cfg
  
  before_filter [:check_authentication], :except => [:login, :logout]
  
  def set_layout
    case action_name.to_s
    when "login"
      "admin_login"
    else
      "admin"
    end
  end
  
  def check_authentication 
    unless current_user && current_user.roles.any? {|r| %w{Admin Author}.include? r}
      redirect_to admin_login_url
      return false
    end 
  end
  
  def check_role(role)
    unless current_user && (current_user.roles.include? role.to_s)
      logger.error("401 displayed")
  		render(:file	=> "#{RAILS_ROOT}/public/401.html",	:status	=> "401 Unauthorized")
      return false
    end
  end
  
  def cfg
    Setting.first
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)