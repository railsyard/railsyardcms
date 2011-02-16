class UserMailer < ActionMailer::Base
  def signup_notification(user)
    cfg = Setting.first
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{cfg.site_base_url}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    cfg = Setting.first
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{cfg.site_base_url}/"
  end
  
  def reset_notification(user)  
    cfg = Setting.first
    setup_email(user)  
    @subject    += 'Link to reset your password'  
    @body[:url]  = "http://#{cfg.site_base_url}/reset/#{user.reset_code}"  
  end
  
  protected
    def setup_email(user)
      cfg = Setting.first
      @recipients  = "#{user.email}"
      @from        = "#{cfg.site_name}"
      @subject     = "[#{cfg.site_base_url}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)