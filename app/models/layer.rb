class Layer < ActiveRecord::Base
  belongs_to :scene
  belongs_to :element
  
  attr_accessible :width, :height, :x, :y, :element_id
  
  def add2(element)
    self.element_id = element.id
    return self.save
  end # add2  
  
  def self.batch_import( layers )
    # Step 1: Declare field names
    names = [:id, :scene_id, :width, :height, :x, :y, :element_id]
    
    # Step 2: Fill up values
    values = layers.map { |layer| names.map { |name| layer[name] } }
    
    # Step 3: Batch import
    Layer.import( names, values, :on_duplicate_key_update => [ :width, :height, :x, :y, :element_id ] )
  end # self.batch_import
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

