require 'mms2r'

class Mailer < ActionMailer::Base
  default_url_options[:host] = HOST
  
  def invitation(invitation)
    
    from = DO_NOT_REPLY
    recipients = invitation.recipient_email
    subject = 'Spounce | An Invitation'
    body[:invitation] = invitation    
    
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
