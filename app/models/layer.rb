class Layer < ActiveRecord::Base
  belongs_to :scene
  belongs_to :element
  
  attr_accessible :width, :height, :x, :y
  
  def add2(element)
    self.element_id = element.id
    return self.save
  end # add2  
end # Layer


# == Schema Information
#
# Table name: layers
#
#  id         :integer(4)      not null, primary key
#  scene_id   :integer(4)
#  width      :float           default(0.0)
#  height     :float           default(0.0)
#  x          :float           default(0.0)
#  y          :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#  element_id :integer(4)
#

