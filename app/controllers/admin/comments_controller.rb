class Admin::CommentsController < Admin::AdminController
  
  ## manual authorization
  before_filter do |controller|
    controller.check_role("admin") unless (controller.action_name == "set_editing_language")
  end
  
  ## CanCan authorization - see Ability model
  authorize_resource
  skip_authorization_check :only => :set_editing_language
  
  def index
    @admin_editing_language = admin_editing_language
    @comments = Comment.all
  end
  
  def show
    @admin_editing_language = admin_editing_language
    @comment = Comment.find(params[:id])
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment && @comment.destroy && @comment.errors.empty?
      redirect_to admin_comments_path
    end
  end
  
  def toggle
    @comment = Comment.find(params[:id])
    @error = true unless @comment && @comment.toggle
    # Renders toggle.js.erb
  end
  
end
