class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  
  validates :name, :uniqueness => true, :presence => true, :length => {:minimum => 3}
  validates_uniqueness_of :pretty_url

  def self.all_published
    Category
      .select("categories.id, categories.name, categories.pretty_url, COUNT(*) AS articles_count")
      .joins(:articles)
      .where("articles.published" => true)
      .group("categories.id, categories.name, categories.pretty_url")
      .order("categories.name ASC")
  end

end
