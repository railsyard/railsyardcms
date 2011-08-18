class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  has_many :categories, :through => :categorizations
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 3
  validates_uniqueness_of :name

end