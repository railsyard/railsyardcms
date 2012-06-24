class Article < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :categorizations

  belongs_to :user
  
  validates_presence_of :title
  validates_length_of :title, :minimum => 3, :maximum => 255
  validates_uniqueness_of :pretty_url
  validates_length_of :meta_title, :meta_keywords, :meta_description, :pretty_url, :maximum => 255
  # validates_presence_of :categories
  
  acts_as_commentable
  
  # paperclip
  has_attached_file :featured_image,
                    :styles => {:large => "500x500>", :medium => "300x300>", :thumb => "100x100>", :highlight => "307x132>" },
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  default_scope :order => 'publish_at DESC'
  scope :drafts, :conditions => ["published = ?", false]
  scope :not_reserved, :conditions => ["reserved = ?", false]
  scope :for_public_feed, :conditions => ["reserved = ? AND published = ?", false, true], :order => "publish_at DESC" 
  scope :published, lambda { 
      where("articles.published = ? AND articles.publish_at IS NOT NULL AND articles.publish_at <= ?", true, Time.zone.now)
  }
  
  def publish
    update_attributes!(:published => true)
  end
  
  def unpublish
    update_attributes!(:published => false)
  end
  
  def toggle
    if !self.published
      self.publish
    else
      self.unpublish
    end
  end
  
end
