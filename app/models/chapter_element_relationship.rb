class ChapterElementRelationship < ActiveRecord::Base
  # Relationships
  belongs_to :chapter, :class_name => "Chapter", :foreign_key => :chapter_id
  belongs_to :element, :class_name => "Element", :foreign_key => :element_id
end

# == Schema Information
#
# Table name: chapter_element_relationships
#
#  id         :integer(4)      not null, primary key
#  chapter_id :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

