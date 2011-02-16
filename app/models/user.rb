require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  # will paginate
  cattr_reader :per_page
  @@per_page = 10
  
  has_many :articles
  has_many :pages
  has_many :associations
  
  validates_presence_of     :login
  validates_length_of       :login,     :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,     :with => Authentication.login_regex, :message => Authentication.bad_login_message
  validates_presence_of     :firstname
  validates_length_of       :firstname, :within => 3..40
  validates_presence_of     :lastname
  validates_length_of       :lastname,  :within => 3..40
  validates_presence_of     :email
  validates_length_of       :email,     :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,     :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_presence_of     :roles
  
  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :firstname, :lastname, :lang

  named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  ROLES = %w[Admin Author Premium_User User]

  # Activates the user in the database.
  def activate!
    @activated = true
    self.enabled = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and enabled = 1 and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def create_reset_code
    @reset = true
    self.reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    save(false)
  end  
    
  def recently_reset?
    @reset
  end
    
  def delete_reset_code
    self.reset_code = nil
    save(false)
  end
  
  #set roles bitmask
  def roles=(roles)
    self.roles_mask = (roles.to_a & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  #get roles from bitmask
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  #role to :symbol
  def role_symbols
    roles.map(&:to_sym)
  end
  
  def is_admin?
    self.roles.include?("Admin")
  end
  
  def is_author?
    self.roles.include?("Author")
  end
  
  def is_premium_user?
    self.roles.include?("Premium_User")
  end
  
  def is_privileged?
    self.roles.any? {|r| %w{Admin Author Premim_User}.include? r}
  end
  
  def is_enabled?
    self.enabled == true
  end
  
  def enable
    self.enabled = true
    save(false)
  end
  
  def disable
    self.enabled = false
    save(false)
  end
  
  # def set_role(value)
  #   self.role = value.to_i
  #   save(false)
  # end

  protected
    
  def make_activation_code
    self.activation_code = self.class.make_token
  end


end
# Author::    Silvio Relli  (mailto:silvio@relli.org)
# Credits to Restful Auth gem/plugin