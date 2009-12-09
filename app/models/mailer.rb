require 'mms2r'

class Mailer < ActionMailer::Base
  
  default_url_options[:host] = 'beta.spounce.com'
  
  def invitation(invitation)
    subject    'Spounce | An Invitation'
    recipients invitation.recipient_email
    from       'noreply@spounce.com'
    body       :invitation => invitation
    invitation.update_attribute(:sent_at, Time.now)
  end
  
  def receive(email) 
       
    begin
      mms = MMS2R::Media.new(email)
      
      if user = User.find_by_email(mms.from)
        if mms.default_media.content_type.include?('image')
          user.photos << Photo.create!(:photo => mms.default_media)
        elsif mms.default_media.content_type.include?('video')        
          user.videos << Video.create!(:video => mms.default_media)
        else
          logger.info("Demand for #{mms.default_media.content_type}")
        end
      else
        logger.info("No user found as #{mms.from}.")
      end
      
    ensure
      mms.purge
    end
    
  end
  
end
