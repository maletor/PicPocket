class Asset < ActiveRecord::Base
  
  belongs_to :user
  
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
end
