class User < ActiveRecord::Base
  
  ##
  # Callbacks
  
  after_update :reprocess_avatar, :if => :cropping?
  after_update :save_assets
  before_save :prepare_password
  before_create :make_activation_code
  before_create :set_invitation_limit
  
  ##
  # Associations
  
  has_many :assets, :dependent => :destroy
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  has_attached_file :avatar, :styles => { :small => "100x100#", :large => "500x500>" }, :processors => [:cropper]
  belongs_to :invitation
  
  ## 
  # Scopes
  
  ## 
  # Finders
  
  ## 
  # Validations
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validate :valid_email?
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  validates_presence_of :invitation_id, :message => 'is required.'
  validates_uniqueness_of :invitation_id

  validates_associated :assets

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :password
  attr_accessible :username, :email, :password, :password_confirmation, :reset_code, :invitation_token, :phone  

  def new_asset_attributes=(asset_attributes) 
    asset_attributes.each do |attributes| 
      assets.build(attributes) 
    end 
  end

  def existing_asset_attributes=(asset_attributes) 
    assets.reject(&:new_record?).each do |asset| 
      attributes = asset_attributes[asset.id.to_s] 
      if attributes 
        asset.attributes = attributes 
      else 
        asset.delete(asset) 
      end 
    end 
  end 

  def save_assets 
    assets.each do |asset| 
      asset.save(false) 
    end 
  end 
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end
  
  def valid_email?
    TMail::Address.parse(self.email)
  rescue
    errors.add_to_base("Must be a valid email")
  end

  def invitation_token
    invitation.token if self.invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)      
  end

  ##
  # Login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass) && user.active?
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
    # The nil of an activation code means they have activated
    activation_code.nil?
  end

  private
  
  def reprocess_avatar
    avatar.reprocess!
  end

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

  def set_invitation_limit
    self.invitation_limit = 8
  end

end
