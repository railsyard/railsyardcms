class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable, :omniauthable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :remember_me
  
  has_many :grades
  has_many :roles, :through => :grades
  accepts_nested_attributes_for :grades
  
  before_create :assign_user_role
  
  def assign_user_role
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
  
end
