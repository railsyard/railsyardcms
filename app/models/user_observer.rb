class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) unless user.login == "superadmin"
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated? 
    UserMailer.deliver_reset_notification(user) if user.recently_reset?  
  end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)