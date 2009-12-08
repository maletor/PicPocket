class Video < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :video
  
  validates_attachment_presence :video
  validates_attachment_size :video, :less_than => 20.megabytes
  validates_attachment_content_type :video, :content_type => ['video/avi']
  
end
