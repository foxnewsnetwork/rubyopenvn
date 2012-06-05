class Element < ActiveRecord::Base
  # Relationships
  has_many :scene_data
  has_many :element_relationships
  has_many :user_element_relationships, :dependent => :destroy
  has_many :story_element_relationships, :dependent => :destroy
  has_many :chapter_element_relationships, :dependent => :destroy
  has_many :children, :through => :element_relationships, :foreign_key => :pid
  has_many :parents, :through => :element_relationships, :foreign_key => :cid
  has_many :chapters, :through => :chapter_element_relationships, :foreign_key => :element_id
  has_many :stories, :through => :story_element_relationships, :foreign_key => :element_id
  has_many :users, :through => :user_element_relationships, :foreign_key => :element_id

  # Attachments (be sure to change these for S3 environment in production)
  has_attached_file :picture, :styles => { :small => "50x50>" } ,
    :url => "/images/elements/:id/:style/:basename.:extension" ,
    :path => ":rails_root/public/images/elements/:id/:style/:basename.:extension"
    
  # Validations
  validates_attachment_presence :picture
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/png', 'image/gif']
  
  # Whatever thing is, it needs to have the fork method
  def forked_by(thing)
    a = thing.fork(self)
    return a
  end # forked_by
end # element



# == Schema Information
#
# Table name: elements
#
#  id                   :integer(4)      not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  metadata             :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#

