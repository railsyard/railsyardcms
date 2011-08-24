class ArticleLayout < ActiveRecord::Base
  
  has_many :associations, :dependent => :destroy
  has_many :snippets, :through => :associations, :dependent => :destroy
  
end
