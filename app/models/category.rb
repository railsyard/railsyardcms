class Category < ActiveRecord::Base
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 3
  validates_uniqueness_of :name
  
  has_many :categorizations
  has_many :articles, :through => :categorizations
  has_many :categories, :through => :categorizations
  has_many :tags, :through => :categorizations
  has_many :snippets, :through => :categorizations

end
# Author::    Silvio Relli  (mailto:silvio@relli.org)