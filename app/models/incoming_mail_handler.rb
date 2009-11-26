require 'mms2r'

class IncomingMailHandler < ActionMailer::Base

  ##
  # Receives email(s) from MMS-Email or regular email and 
  # uploads that content the user's photos.
  # TODO: Use beanstalkd for background queueing and processing.
  def receive(email)    
    
    mms = MMS2R::Media.new(email)
    
    ## 
    # Ok to find user by email as long as activate upon registration.
    # Remember to make UI option that users can opt out of registration 
    # and either not send emails or send them to a username+32523@picpocket.com
    # type address.
    ##
    # Remember to get SpamAssasin
    if (user = User.find_by_email(email.from) && email.has_attachments?)
      mms.media.each do |key, value|
        if key.include?('image')
          value.each do |file| 
            photo = Photo.create!(:uploaded_data => File.open(file), :title => email.subject.empty? ? "Untitled" : email.subject)
            user.photos << photo
          end
        end
      end
    end   
    
    mms.purge
    
  end

end
