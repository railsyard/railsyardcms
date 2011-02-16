class CreateNewSuperadmin < ActiveRecord::Migration
  def self.up 
    prev_adm = User.find(:first, :conditions => [ "login = ?", "superadmin"])
    prev_adm.destroy unless prev_adm.nil?
      
    adm = User.create :login => "superadmin", :firstname => "super", :lastname => "admin", :email => "superadmin@example.com", :password => "superadmin", :password_confirmation => "superadmin"
    adm.update_attribute(:id, 1)
    adm.update_attribute(:activated_at, Time.now)
    adm.update_attribute(:roles_mask, 1)
    adm.update_attribute(:enabled, 1)
    adm.update_attribute(:activation_code, nil)
  end

  def self.down
    prev_adm = User.find(:first, :conditions => [ "login = ?", "superadmin"])
    prev_adm.destroy unless prev_adm.nil?
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)