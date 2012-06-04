class StoryElementRelationship < ActiveRecord::Base
  belongs_to :story, :class_name => "Story", :foreign_key => :story_id
  belongs_to :element, :class_name => "Element", :foreign_key => :element_id
end

# == Schema Information
#
# Table name: story_element_relationships
#
#  id         :integer(4)      not null, primary key
#  story_id   :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

