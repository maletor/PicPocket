require 'mms2r'
# require 'action_controller'
# require 'action_controller/test_process.rb'

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
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@spounce.com"
      @subject     = "[beta.spounce.com] "
      @sent_on     = Time.now
      @body[:user] = user
    end

  ##
  # Receives email(s) from MMS-Email or regular email and 
  # uploads that content the user's photos.
  # TODO Use beanstalkd for background queueing and processing.
  # TODO Remember to get SpamAssasin for production
  # TODO Maybe see if thoughtbot's paperclip could provide something a little cleaner
  # TODO This should be done with BackgroundRB
  def receive(email)    
    begin
      mms = MMS2R::Media.new(email)
      
      ## 
      # Ok to find user by email as long as activate upon registration.
      # Remember to make UI option that users can opt out of registration 
      # and either not send emails or send them to a username+32523@spounce.com
      # type addresss
      
      if user = User.find_by_email(mms.from)
        mms.media.each do |key, files|
          if key.include?('image')
            files.each do |path|
              mimetype = key
              
              photo = Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(path, mimetype))
              photo.save
              user.photos << photo 
              
              # file = File.new(path)
              #               
              #               
              # def file.local_path
              #   self.path
              # end
              # 
              # def file.original_filename
              #   File.basename(self.path)
              # end
              # 
              # def file.size
              #   File.size(self.path)
              # end
              # 
              # class << file
              #   self
              # end.send(:define_method, :content_type) { mime_type }
              #               
              # user.photos << Photo.create(:uploaded_data => file)
              
            end
          end
        end
      end
      
      
    ensure
      
      mms.purge
      
    end
        
  end
end
