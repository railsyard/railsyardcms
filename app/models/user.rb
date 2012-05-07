class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :remember_me, :lang, :pretty_url
  
  has_many :grades
  has_many :roles, :through => :grades
  accepts_nested_attributes_for :grades
  has_many :articles

  # before_create :assign_user_role
  before_save :set_default_values

  validates :email, :presence => true, :uniqueness => true
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :password, :presence => true, :length => { :minimum => 8 }
  validates :password_confirmation, :presence => true, :length => { :minimum => 8 }
  
  scope :admins, includes(:grades, :roles).where("roles.name = ?", "admin")
  scope :writers, includes(:grades, :roles).where("roles.name = ?", "article_writer")
  scope :premiums, includes(:grades, :roles).where("roles.name = ?", "premium_user")

  # = CSV export =
  comma do
    id
    email
    firstname
    lastname

    roles { |roles| roles.uniq.collect {|r| r.name}.join ',' }
    created_at 'Joined date'
  end

  # = Instance methods =
  def set_default_values
    self.lang = 'en' unless self.lang
    self.roles << Role.find_by_name('registered_user')
  end

  def is_admin?
    self.role?('admin')
  end

  def is_article_writer?
    self.role?('article_writer')
  end

  def is_premium_user?
    self.role?('premium_user')
  end

  def is_privileged?
    self.roles.map{|r| r.name}.any? {|r| %w{admin article_writer premium_user}.include? r}
  end

  # Check if user has one of the roles listed inside roles_array
  def roles?(roles_array)
    return !!self.roles.map{|r| r.name}.any? {|r| roles_array.include? r}
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end

  def set_roles(roles=[])
    self.roles.clear
    unless roles.blank?
      roles.map do |role|
        self.roles << Role.find(role)
      end
    end
  end

  def toggle
    self.update_attribute(:enabled, !self.enabled)
  end

  def enable!
    self.update_attribute(:enabled, true)
    self.update_attribute(:confirmed_at, Time.now) if self.confirmed_at.blank?
  end

  def disable!
    self.update_attribute(:enabled, false)
  end

end
