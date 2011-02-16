class Article < ActiveRecord::Base
  #acts_as_commentable
  
  # will paginate
  cattr_reader :per_page
  @@per_page = 10
  
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :tags, :through => :categorizations
  #accepts_nested_attributes_for :categorizations
  #accepts_nested_attributes_for :categories
  
  has_many :assets, :as => :attachable, :dependent => :destroy
  #accepts_nested_attributes_for :assets
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  belongs_to :user
  
  validates_presence_of :title
  validates_length_of :title, :minimum => 3
  validates_uniqueness_of :pretty_url
  validates_presence_of :categories
  
  default_scope :conditions => {:deleted => false}
  
  named_scope :published, :conditions => ["published = ?", true]
  named_scope :drafts, :conditions => ["published = ?", false]
  named_scope :not_reserved, :conditions => ["reserved = ?", false]
  named_scope :for_public_feed, :conditions => ["reserved = ? AND published = ?", false, true], :order => "publish_at DESC"
  
  def publish
    update_attributes!(:published => true, :publish_at => Time.now)
  end
  
  def unpublish
    update_attributes!(:published => false, :publish_at => nil)
  end
  
  def toggle
    if !self.published
      self.publish
    else
      self.unpublish
    end
  end
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)