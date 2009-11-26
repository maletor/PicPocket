class Mailman < ActionMailer::Base
 
  def receive(email)
    logger.info("Got an email about: #{email.subject}") 

    if (@user = User.find_by_email(email.from))
      if email.has_attachments?        
        for attachment in email.attachments
          if attachment.content_type == "image"
            @photo = Photo.new(:uploaded_data => attachment)
            @user.photos << @photo
          end
        end
      end
    else
      logger.info("No user found with email: #{email.from}") 
    end   
  end
  
end
