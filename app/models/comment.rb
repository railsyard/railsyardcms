class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at DESC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # Comments belong to a user, but not required
  belongs_to :user
  
  validates :email, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true
  validates :body, :presence => true
  
  scope :published, where(:published => true)
  
  self.per_page = 10
  
  def publish
    update_attributes!(:published => true)
  end
  
  def unpublish
    update_attributes!(:published => false)
  end
  
  def toggle
    if !self.published
      self.publish
    else
      self.unpublish
    end
  end
  
end
