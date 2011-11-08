class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  
  validates :name, :uniqueness => true, :presence => true, :length => {:minimum => 3}

end