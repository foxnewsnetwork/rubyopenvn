class Scene < ActiveRecord::Base
  # relationships
  belongs_to :author, :class_name => "User", :foreign_key => :owner_id
  belongs_to :chapter
  belongs_to :parent, :class_name => "Scene"
  has_many :children, :class_name => "Scene", :foreign_key => :parent_id
  has_many :scene_data, :class_name => "SceneData", :dependent => :destroy
  
  # Attributes
  attr_accessible :number
  
  # spawns children; use this instead of self.children.create
	def spawn
		child = self.children.create!
		child.chapter_id = self.chapter_id
		child.save
		return child
	end # spawn
  
  def load_dirty
    
  end # load_dirty
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
#  number     :integer(4)
#  owner_id   :integer(4)
#

