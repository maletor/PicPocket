require 'mms2r'

class IncomingMailHandler < ActionMailer::Base

  def receive(email)    
    
    mms = MMS2R::Media.new(email)
    logger.info("Got an email about: #{email.subject}") 
    
    if (@user = User.find_by_email(email.from))
      @photo = Photo.new(:uploaded_data => mms.default_media, :title => mms.subject.empty? ? "Untitled" : mms.subject)
      @user.photos << @photo
    else
      logger.info("No user found with email: #{email.from}") 
    end   
  end

end
