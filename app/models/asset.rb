class Asset < ActiveRecord::Base
  
  belongs_to :user
  
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 5.megabytes
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/png']

end
