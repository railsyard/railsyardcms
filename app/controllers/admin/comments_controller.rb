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
  
end
