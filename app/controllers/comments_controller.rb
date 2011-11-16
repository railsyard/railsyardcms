class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment && @comment.save && @comment.errors.empty?
      respond_to do |format|
        format.js {
          render :js => "window.location.reload();"
        }
        # To-do insert the comment via ajax instead of reloading
      end
    else
      respond_to do |format|
        format.js {
          render :js => "alert('Something went wrong!');"
        }
      end
    end
    
  end
  
end
