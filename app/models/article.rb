class Article < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :tags, :through => :categorizations
  
  belongs_to :user
  
  validates_presence_of :title
  validates_length_of :title, :minimum => 3
  validates_uniqueness_of :pretty_url
  # validates_presence_of :categories
  
  scope :published, :conditions => ["published = ?", true]
  scope :drafts, :conditions => ["published = ?", false]
  scope :not_reserved, :conditions => ["reserved = ?", false]
  scope :for_public_feed, :conditions => ["reserved = ? AND published = ?", false, true], :order => "publish_at DESC"
    
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
