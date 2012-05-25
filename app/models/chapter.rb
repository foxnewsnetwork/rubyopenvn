class Chapter < ActiveRecord::Base
  # functionality
  attr_accessible :title
  
  # relationships
  belongs_to :story
  has_many :scenes, :dependent => :destroy 
  belongs_to :parent, :class_name => "Chapter"
  has_many :children, :class_name => "Chapter", :foreign_key => :parent_id

	# spawns children; use this instead of self.children.create
	def spawn(data)
		child = self.children.create!(data)
		child.story_id = self.story_id
		child.save
		return child
	end # spawn
	
	public :spawn
end # Chapter


# == Schema Information
#
# Table name: chapters
#
#  id         :integer(4)      not null, primary key
#  story_id   :integer(4)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)     default("Untitled")
#

