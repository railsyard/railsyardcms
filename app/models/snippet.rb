class Snippet < ActiveRecord::Base
  
  has_one :association, :dependent => :destroy
  has_one :page, :through => :association
  has_one :template, :through => :association
  has_many :categorizations
  has_many :categories, :through => :categorizations
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 3
  
  #default_scope :order => 'position ASC'
  named_scope :for_header, :conditions => ["location = ?", "header"], :order => "position ASC"
  named_scope :for_left, :conditions => ["location = ?", "left"], :order => "position ASC"
  named_scope :for_center, :conditions => ["location = ?", "center"], :order => "position ASC"
  named_scope :for_right, :conditions => ["location = ?", "right"], :order => "position ASC"
  named_scope :for_footer, :conditions => ["location = ?", "footer"], :order => "position ASC"
  named_scope :for_extra, :conditions => ["location = ?", "extra"], :order => "position ASC"
  
  #fix-me move inside attachment snippet model
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_many :images, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :assets
  
  
  # override "type" reserved attribute name for the select tag
  def kind
    self[:type]
  end
  
  def kind=(type)
    self[:type] = type
  end
  
  # TO-DO get them reading the directory contents instead of hardcoded
  def self.type_to_select
    [["Content with WYSIWYM editor","EditableContentSnippet"],
  #  ["Content with plain HTML","PlainEditableContentSnippet"],
    ["Menu - First level pages","FirstlevelMenuSnippet"],
    ["Menu - Second level pages","SecondlevelMenuSnippet"],
    ["Menu - First and second level pages","TwolevelsMenuSnippet"],
    ["Menu - Children pages","ChildrenMenuSnippet"],
    ["Menu - Siblings pages","SiblingsMenuSnippet"],
    ["Menu - Siblings and children pages","SibChildMenuSnippet"],
    ["Menu - Footer","FooterMenuSnippet"],
    ["Articles - Index","ArticlesSnippet"],
    ["Articles - Carousel","ArticlesCarouselSnippet"],
    ["Articles - Last article","LastArticleSnippet"],
    ["Image gallery","GallerySnippet"],
    ["Downloads","AttachmentsSnippet"],
    ["Action/Controller","ActionControllerSnippet"]]
  end
  
  def self.location_to_select
    [["Header","header"],
    ["Left column","left"],
    ["Center","center"],
    ["Right column","right"],
    ["Footer","footer"],
    ["Extra area","extra"]]
  end
  
  def publish
    update_attributes!(:published => true, :publish_at => Time.now)
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
# Author::    Silvio Relli  (mailto:silvio@relli.org)