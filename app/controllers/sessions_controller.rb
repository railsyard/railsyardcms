class SessionsController < ApplicationController

  layout :set_layout

  # render new.rhtml
  def new
    @cfg = cfg
  end

  def create
    @cfg = cfg
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      flash[:notice] = t("session.logged_in_successfully")
      
      if params[:admin_panel] && params[:admin_panel] == 'true'
        destination = user.roles.include?("Admin") ? admin_pages_path : admin_articles_path
        redirect_to destination
      else
        redirect_to '/'
      end
       
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      
      flash[:notice] = t("session.user_or_password_not_valid")
      
      if params[:admin_panel] && params[:admin_panel] == 'true'
        redirect_to admin_login_path
      else
        redirect_to '/'
      end
      
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t("session.logged_in_successfully")
    redirect_to '/'
  end
  
  private
  
  def set_layout
    Layout.find(@cfg.theme_name, 'signup').path
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    #flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)
# Credits to Restful Auth gem/plugin