class Photo < ActiveRecord::Base
  belongs_to :user
  
  has_many :votes
  
  named_scope :private, :conditions => {:status => 'private', :flagged => false}
  named_scope :public, :conditions => {:status => 'public', :flagged => false}
  named_scope :trashed, :conditions => {:status => 'trashed', :flagged => false}  
  
  has_attached_file :photo
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  def flag
    self.flagged = true
    increment!(:flag_count)
    save(false)
  end
  
end
