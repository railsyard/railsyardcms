class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment && @comment.save && @comment.errors.empty?
      respond_to do |format|
        format.js {
          render :js => "window.location.reload();"
        }
        format.html {
          if @comment.commentable_type == "Article"
            @article = Article.find(@comment.commentable_id)
            redirect_to get_article_url(@article)
          end
        }
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
