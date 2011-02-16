class CommentsController < ApplicationController
  
  def create
    commentable = params[:comment][:commentable_type].classify.constantize.find(params[:comment][:commentable_id])
    if commentable
      params[:comment].delete(:commentable_type)
      params[:comment].delete(:commentable_id)
      @comment = commentable.comments.new(params[:comment])
      @comment.user = current_user
      if @comment && @comment.save && @comment.errors.empty?
        render :update do |page|
          page.visual_effect(:fade, "comment_form", :duration => 1)
          page.insert_html :bottom, 'comments_list', :partial => "comments/item", :object => @comment, :locals => {:style => "display:none"}
          page << "Element.show('comments_list')"
          page.visual_effect(:appear, "comment_#{@comment.id}", :duration => 1)
        end
      else
        render :nothing => true
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if ((@comment.user_id == current_user.id) || (@comment.commentable.user_id == current_user.id || current_user.is_admin?))
      @comment.destroy
      render :update do |page|
        page.visual_effect(:fade, "comment_#{@comment.id}", :duration => 1)
      end
    end  
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)