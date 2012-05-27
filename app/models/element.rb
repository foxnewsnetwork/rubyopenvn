class Element < ActiveRecord::Base
  has_many :scene_data
  has_many :children, :through => :element_relationships, :foreign_key => :pid
  has_many :parents, :through => :element_relationships, :foreign_key => :cid
end


# == Schema Information
#
# Table name: elements
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  metadata   :string(255)
#

