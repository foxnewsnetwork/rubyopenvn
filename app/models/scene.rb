class Scene < ActiveRecord::Base
  # relationships
  belongs_to :chapter
  belongs_to :parent, :class_name => "Scene"
  has_many :children, :class_name => "Scene", :foreign_key => :parent_id
  
  # spawns children; use this instead of self.children.create
	def spawn
		child = self.children.create!
		child.chapter_id = self.chapter_id
		child.save
		return child
	end # spawn
end

# == Schema Information
#
# Table name: scenes
#
#  id         :integer(4)      not null, primary key
#  chapter_id :integer(4)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

