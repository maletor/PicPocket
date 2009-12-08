class Event < ActiveRecord::Base
  attr_accessible :title
  
  has_many :adventures
  has_many :users, :through => :adventures
  
end
