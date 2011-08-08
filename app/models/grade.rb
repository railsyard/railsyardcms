class Grade < ActiveRecord::Base
  #attr_accessible #none
  validates :user_id, :presence => true
  validates :role_id, :presence => true
  belongs_to :user
  belongs_to :role
  
end
