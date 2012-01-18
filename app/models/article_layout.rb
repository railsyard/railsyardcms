class ArticleLayout < ActiveRecord::Base
  
  has_many :pastes, :dependent => :destroy
  has_many :snippets, :through => :pastes, :dependent => :destroy
  
end
