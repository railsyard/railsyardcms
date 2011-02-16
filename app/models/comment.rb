class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'
  
  validates_presence_of :body
  
  #attr_accessible :body

end
