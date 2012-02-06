class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.published = true
    if @comment && verify_recaptcha(:model => @comment) && @comment.save && @comment.errors.empty?  
      if @comment.commentable_type == "Article"
        @article = Article.find(@comment.commentable_id)
        @commentable_url = get_article_url(@article)
      else
        #add your commentable here
        @commentable_url = "/"
      end
      respond_to do |format|
        format.js {
          render :js => "window.location = \"#{@commentable_url}\";"
        }
        format.html {
          redirect_to @commentable_url
        }
      end
    else
      respond_to do |format|
        format.js {
          render :js => "Recaptcha.reload(); alert('#{@comment.errors.full_messages.join("; ")}');"
        }
      end
    end
    
  end
  
end
