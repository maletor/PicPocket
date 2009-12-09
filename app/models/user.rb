class User < ActiveRecord::Base
  include Clearance::User
  
  before_create :set_invitation_limit
  

  has_many :photos
  accepts_nested_attributes_for :photos
  
  has_many :videos
  
  has_many :adventures
  has_many :events, :through => :adventures
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  
  has_attached_file :avatar, :styles => { :small => "150x150>" },
                    :url  => "/assets/users/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension",
                    :default_url => '/images/anonymous.png'
  
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
      
  validates_presence_of :invitation_id, :message => 'is required.'
  validates_uniqueness_of :invitation_id
  
  attr_accessible :invitation_token, :avatar, :address, :username, :phone, :email

  def invitation_token
    invitation.token if self.invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)      
  end

  private
  
  def set_invitation_limit
    self.invitation_limit = 8
  end

end
