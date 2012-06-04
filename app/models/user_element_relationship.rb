class UserElementRelationship < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => :user_id
  belongs_to :element, :class_name => "Element", :foreign_key => :element_id
end

# == Schema Information
#
# Table name: user_element_relationships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

