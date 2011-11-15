class CommentsController < ApplicationController
  
  def create
    @comment = Comment.create(params[:comment])
  end
  
end
