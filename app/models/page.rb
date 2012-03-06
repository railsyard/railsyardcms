class Page < ActiveRecord::Base

  # Concerns
  has_ancestry
  has_attached_file :featured_image,
                    :styles => {:large => "500x500>", :medium => "300x300>", :thumb => "100x100>", :banner => "960x303>" },
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  # Mass-assignable attributes
  attr_accessible :title, :pretty_url, :published, :publish_at,
                  :visible_in_menu, :meta_title, :meta_description,
                  :meta_keywords, :script, :div_id, :div_class, :div_style,
                  :reserved, :layout_name, :lang, :position, :featured_image

  # Relations
  has_many :pastes, :dependent => :destroy
  has_many :snippets, :through => :pastes, :dependent => :destroy

  # Validations
  validates :title,
            :presence => true,
            :length => { :minimum => 2 }

  validates :pretty_url,
            :presence => true,
            :uniqueness => true

  validates :lang,
            :presence => true

  # Hooks
  before_create :set_order

  # Scopes
  default_scope :order => "position ASC"
  scope :published, where(:published => true)
  scope :drafts, where(:published => false)
  scope :for_language, lambda { |lang| where(:lang => lang) }
  scope :not_reserved, where("reserved IS NULL OR reserved = ?", false)
  scope :without_roots, where("ancestry IS NOT NULL")

  # Public methods

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

  def is_reserved?
    reserved == true
  end

  private

  def set_order
    max_sibling = siblings.order("position DESC").first
    self.position ||= max_sibling.present? ? max_sibling.position + 1 : 1
  end

end
