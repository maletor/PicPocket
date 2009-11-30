require 'mms2r'

class UserMailer < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://beta.spounce.com/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://beta.spounce.com/"
  end
  
  def reset_notification(user)
    setup_email(user)
    @subject    += 'Link to reset your password'
    @body[:url]  = "beta.spounce.com/reset/#{user.reset_code}"
  end
  
  def invitation(invitation, signup_url)
    subject = 'Spounce | An invitation'
    recipients = invitation.recipient_email
    from = 'noreply@spouncemail.com'
    body[:invitation] = invitation
    body[:signup_url] = signup_url
    invitation.update_attribute(:sent_at, Time.now)
  end

  ##
  # Receives email (only one) from MMS-Email or regular email and 
  # uploads that content to the user's photos.
  # TODO Use background queueing and processing.
  # TODO Remember to get SpamAssasin for production
  def receive(email)    
    begin
      mms = MMS2R::Media.new(email)
      
      if user = User.find_by_email(mms.from)
        user.assets << Asset.create!(:file => mms.default_media)           
      else
        logger.info("No user found as #{mms.from}.")
      end
      
    ensure
      mms.purge
    end
  end
  
  protected
  
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "no-reply@spounce.com"
    @subject     = "Spounce | "
    @sent_on     = Time.now
    @body[:user] = user
  end
  
end
