require 'mms2r'

class IncomingMailHandler < ActionMailer::Base

  def receive(email)    
    
    mms = MMS2R::Media.new(email)
    
    ## 
    # Ok to find user by email as long as activate upon registration.
    # Remember to make UI option that users can opt out of registration 
    # and either not send emails or send them to a username+32523@picpocket.com
    # type address.
    if (@user = User.find_by_email(email.from))
      mms.media.each do |key, value|
        if key.include('image')
          @photo = Photo.new(:uploaded_data => value, :title => value.subject.empty? ? "Untitled" : value.subject)
          @user.photos << @photo
      end
    else
      ##
      # Remember to get SpamAssasin
      logger.info("No user found with email: #{email.from}") 
    end   
    
    mms.purge
    
  end

end
