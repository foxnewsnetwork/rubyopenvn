class Story < ActiveRecord::Base
  attr_accessible :summary
  
  # relationships (and anonymous modules)
  belongs_to :author, :class_name => "User", :foreign_key => :owner_id
  has_many :chapters 
  
  validates :title, :presence => true  
end


# == Schema Information
#
# Table name: stories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  owner_id   :integer(4)
#  summary    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

