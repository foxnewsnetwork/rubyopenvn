class Chapter < ActiveRecord::Base
  # functionality
  attr_accessible :title
  
  # relationships
  belongs_to :author, :class_name => "User", :foreign_key => :owner_id
  belongs_to :story
  has_many :scenes, :dependent => :destroy 
  belongs_to :parent, :class_name => "Chapter"
  has_many :children, :class_name => "Chapter", :foreign_key => :parent_id do 
    def create(*data)
      chapter = Chapter.new(data)
      chapter.story_id = proxy_owner.story_id
      chapter.owner_id = proxy_owner.owner_id
      chapter.parent_id = proxy_owner.id
      chapter.save
      return chapter
    end # create
  end # has_many

	# spawns children; use this instead of self.children.create
	def spawn(*data)
		child = self.children.create!(data)
		child.story_id = self.story_id
    child.owner_id = self.owner_id
		child.save
		return child
	end # spawn
  
	def dirty_jsonify
    sids = self.scenes # 1
    sdids = SceneData.where(:id => sids) # 2
    relationships = ElementRelationship.where(:sid => sdids) # 3
    eid = []
    relationships.each do |x|
      eid << x.pid
      eid << x.cid
    end # each
    elements = Element.where(:id => eid) # 4
    return { :scenes => sids, :scene_data => sdids, :relationships => relationships, :elements => elements }.as_json
  end # dirty_jsonify
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
#  owner_id   :integer(4)
#

