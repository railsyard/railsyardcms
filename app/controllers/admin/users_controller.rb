class Admin::UsersController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_role("admin")
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  
  def index
    @admin_editing_language = admin_editing_language
    @users = User.all
  end
  
  def new
    @admin_editing_language = admin_editing_language
    @user = User.new
  end
  
  def create
    @admin_editing_language = admin_editing_language
    @user = User.new(params[:user])
    @user.set_roles(params[:user][:role_ids])
    if @user && @user.save && @user.errors.empty?
      params[:user][:enabled] == '1' ? @user.enable! : @user.disable!
      redirect_to admin_users_path
    else
      render :action => "new"
    end
  end
  
  def edit
    @admin_editing_language = admin_editing_language
    @user = User.find(params[:id])
  end
  
  def update
    @admin_editing_language = admin_editing_language
    @user = User.find(params[:id])
    # Deletes password parameters if empty field so you can edit user details without changing password
    if params[:user][:password].empty? && params[:user][:password_confirmation].empty?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    @user.set_roles(params[:user][:role_ids])
    @user.attributes = params[:user] unless @user.blank?
    if @user && @user.save && @user.errors.empty?
      params[:user][:enabled] == '1' ? @user.enable! : @user.disable!
      redirect_to admin_users_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end
  
  def toggle
    @user = User.find(params[:id])
    @error = true unless @user && @user.toggle
    # Renders toggle.js.erb
  end
  
end
