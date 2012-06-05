class Chapter < ActiveRecord::Base
  # functionality
  attr_accessible :title, :cover
  
  # Attachments (be sure to change these for S3 environment in production)
  has_attached_file :cover, :styles => { :small => "50x50>" } ,
    :url => "/images/chapters/:id/:style/:basename.:extension" ,
    :path => ":rails_root/public/images/chapters/:id/:style/:basename.:extension"
  validates_attachment_size :cover, :less_than => 5.megabytes
  validates_attachment_content_type :cover, :content_type => ['image/png', 'image/gif', 'image/jpg']
  
  # relationships
  has_many :chapter_element_relationships, :dependent => :destroy
  has_many :elements, :through => :chapter_element_relationships, :foreign_key  => :chapter_id do
    def create(*data)
      element = Element.create!(data)
      proxy_owner.fork(element)
      return element
    end # create
  end # has_many
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

  # forks elements
  def fork(element)
    begin
      self.story.fork(element)
      a = ChapterElementRelationship.create!(:chapter_id => self.id, :element_id => element.id)
      return a
    rescue
      return nil
    end # begin-rescue
  end # fork
  
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
#  id                 :integer(4)      not null, primary key
#  story_id           :integer(4)
#  parent_id          :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  title              :string(255)     default("Untitled")
#  owner_id           :integer(4)
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer(4)
#  cover_updated_at   :datetime
#

