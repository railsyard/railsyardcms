class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  
  validates :name, :uniqueness => true, :presence => true, :length => {:minimum => 3}

  def self.all_published
    Category.joins( :articles ).
      select( "categories.*" ).
      select( "COUNT(*) AS articles_count" ).
      where( "articles.published" => true ).
      group( "categories.id" ).
      order( "categories.name ASC" )
  end

end
