class ElementRelationship < ActiveRecord::Base
  belongs_to :parents, :class_name => "Element", :foreign_key => :pid
  belongs_to :children, :class_name => "Element", :foreign_key => :cid # this is really dumb and should be removed
  belongs_to :scene_data, :foreign_key => :sid

	attr_accessible :width, :height, :left, :top, :pid, :cid, :sid, :zindex
end


# == Schema Information
#
# Table name: element_relationships
#
#  id         :integer(4)      not null, primary key
#  width      :float           default(0.0)
#  height     :float           default(0.0)
#  left       :float           default(0.0)
#  top        :float           default(0.0)
#  pid        :integer(4)
#  cid        :integer(4)
#  sid        :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  zindex     :integer(4)      default(0)
#

