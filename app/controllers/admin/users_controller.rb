class Admin::UsersController < Admin::AdminController
  
  before_filter do |controller|
    controller.check_role("Admin")
  end
  
  def index
    @users = User.paginate  :all,
                            :order => "id DESC",
                            :page => params[:pagination]
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.roles = params[:user][:roles] unless @user.blank?
    @user.enabled = params[:user][:enabled] unless @user.blank?
    @user.activate! if (@user.enabled && !@user.active?)
    if @user && @user.save && @user.errors.empty?
      redirect_to admin_users_path
    else
      render :action => "new"
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user] unless @user.blank?
    @user.roles = params[:user][:roles] unless @user.blank?
    @user.enabled = params[:user][:enabled] unless @user.blank?
    @user.activate! if (@user.enabled && !@user.active?)
    if @user && @user.save && @user.errors.empty?
      redirect_to admin_users_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end

end
# Author::    Silvio Relli  (mailto:silvio@relli.org)