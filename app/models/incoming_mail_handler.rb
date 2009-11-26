require 'mms2r'

class IncomingMailHandler < ActionMailer::Base

  ##
  # Receives email(s) from MMS-Email or regular email and 
  # uploads that content the user's photos.
  # TODO: Use beanstalkd for background queueing and processing.
  # TODO: Remember to get SpamAssasin
  def receive(email)    
    begin
      mms = MMS2R::Media.new(email)
      
      ## 
      # Ok to find user by email as long as activate upon registration.
      # Remember to make UI option that users can opt out of registration 
      # and either not send emails or send them to a username+32523@picpocket.com
      # type addresss
      user = User.find_by_email(email.from)
      
      if (user && email.has_attachments?)
        mms.process do |media_type, files|
          for file in files
            user.photos.push Photo.create(:uploaded_data => files.first, :title => "From mail") if media_type =~ /image/
          end
        end
      end
      
    ensure
      
      mms.purge
      
    end
        
  end
end
