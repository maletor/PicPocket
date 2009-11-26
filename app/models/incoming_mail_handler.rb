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
      user = User.find_by_email(mms.from)

      mms.media.each do |key, value|
        if key.includes?('image')
          for file in value
            if user && media.content_type.include?('image')
            
              file.local_path = file.path
              file.original_filename = File.basename(file.path)
              file.size = File.size(file.path)
              user.photos << Photo.create(:uploaded_data => file)
              
            end
          end
        end
      end
      
      
    ensure
      
      mms.purge
      
    end
        
  end
end
