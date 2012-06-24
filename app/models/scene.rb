class Scene < ActiveRecord::Base
  # relationships
  belongs_to :author, :class_name => "User", :foreign_key => :owner_id
  belongs_to :chapter
  belongs_to :parent, :class_name => "Scene"
  has_many :children, :class_name => "Scene", :foreign_key => :parent_id
  has_many :scene_data, :class_name => "SceneData", :dependent => :destroy
  has_many :layers, :dependent => :destroy
  
  # Attributes
  attr_accessible :number, :fork_text, :fork_number, :text
  
  # spawns children; use this instead of self.children.create
	def spawn
		child = self.children.create!
		child.chapter_id = self.chapter_id
		child.save
		return child
	end # spawn
  
  def fork(data)
    child = self.spawn
    child.fork_text = data[:fork_text]
    child.fork_number = data[:fork_number]
    child.owner_id = data[:owner_id]
    child.save
    return child
  end # fork
    
  def self.batch_import( scenes )

    # Step 1 : Declare field names
    names = [ :id, :chapter_id, :parent_id, :owner_id, :fork_text, :fork_number, :text ]
    
    # Step 2: Fill up field values
    values = scenes.map { |scene| names.map { |name| scene[name] } }
    
    # Step 3: Import
    Scene.import( names, values, :on_duplicate_key_update => [:fork_text, :fork_number, :text] )
  end # batch_import
end


# == Schema Information
#
# Table name: scenes
#
#  id          :integer(4)      not null, primary key
#  chapter_id  :integer(4)
#  parent_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  number      :integer(4)
#  owner_id    :integer(4)
#  fork_text   :string(255)
#  fork_number :integer(4)      default(0)
#  text        :text
#

