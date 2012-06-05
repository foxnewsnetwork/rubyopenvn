class SceneData < ActiveRecord::Base
  belongs_to :scene 
	belongs_to :element
  has_many :element_relationships, :foreign_key => :sid, :dependent => :destroy
  attr_accessible :scene_id, :element_id, :width, :height, :left, :top
  def load_dirty
    # Step 1: Pull out all the element relationships
    relationships = self.element_relationships
    ids = [self.element_id]
    relationships.each do |relationship|
      ids << relationship.parent_id
      ids << relationship.child_id
    end # each
    elements = Element.where(:id => ids)
    
    return { :elements => elements, :relationships => relationships }
  end # load_dirty
  
  def relate(data)
		elrel = ElementRelationship.new(data)
		elrel.sid = self.id
    elrel.pid = data[:parent].id
    elrel.cid = data[:child].id
    return elrel if elrel.save
    return false
  end # relate
end # SceneData



# == Schema Information
#
# Table name: scene_data
#
#  id         :integer(4)      not null, primary key
#  scene_id   :integer(4)
#  element_id :integer(4)
#  width      :float           default(0.0)
#  height     :float           default(0.0)
#  left       :float           default(0.0)
#  top        :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#  zindex     :integer(4)      default(0)
#  dialogue   :text
#

