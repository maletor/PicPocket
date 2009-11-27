class User < ActiveRecord::Base
  
  has_many :photos, :as => :attachable
  
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :reset_code
  
  attr_accessor :password
  before_save :prepare_password
  before_create :make_activation_code 
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  def recently_activated?
    @activated
  end
  
  def recently_reset?
    @reset
  end
  
  #reset methods
  def create_reset_code
    @reset = true
    self.attributes = {:reset_code => Digest::SHA1.hexdigest([Time.now, rand].join)}
    save(false)
  end

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end
  
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
  
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
end
