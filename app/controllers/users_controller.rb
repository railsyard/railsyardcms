class UsersController < ApplicationController

  layout :set_layout
  before_filter [:set_default_variables]

  def new
    set_default_variables
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.roles = "User"
    @user.enabled = false
    if @user && @user.save && @user.errors.empty?
      redirect_to '/'
      #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      flash[:notice] = t "public.users.registration_completed"
    else
      #flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      #flash[:notice] = "Signup complete! Please sign in to continue."
      flash[:notice] = t "public.users.activated"
      redirect_to '/'
    when params[:activation_code].blank?
      #flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      flash[:error] = t "public.users.activation_code_missing"
      redirect_to '/'
    else 
      #flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      flash[:error] = t "public.users.activation_error"
      redirect_to '/'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    redirect_to '/' unless (current_user && @user && current_user == @user)
  end
  
  def update
    @user = User.find(params[:id])
    if current_user && @user && (current_user == @user) && !params[:user].blank?
      @user.attributes = params[:user]
      if @user.save && @user.errors.empty?
        flash[:notice] = t "public.users.user_successfully_modified"
        redirect_to '/'
      else
        render :action => "edit"
      end
    else
      redirect_to '/'
    end
  end
  
  
  def forgot
    if request.post? && params[:user][:email]
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash[:notice] = t("public.users.reset_code_sent", :email => params[:user][:email])
        redirect_to login_path
      else
        flash[:error] = t("public.users.address_not_found", :email => params[:user][:email])
        redirect_to login_path
      end 
    end  
  end
  
  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post? && params[:reset_code] && params[:user][:password] && params[:user][:password_confirmation] && @user
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = t("public.users.password_reset_successfully", :email => @user.email)
        redirect_to root_url
      else
        render :action => :reset
      end
    end
  end
  
  private
  
  def set_layout
    Layout.find(@cfg.theme_name, 'signup').path
  end
  
  def set_default_variables
    @cfg = cfg
    @hp = yard_home
    @meta_title = "Signup - #{@cfg.site_name} #{@cfg.site_page_title}"
    @meta_desc = "Signup - #{@cfg.site_desc}"
    @meta_keyword = "#{@cfg.site_keyword}"
    @first_level_pages = @hp.self_and_siblings.for_language(get_lang)  
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)