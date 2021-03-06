class Story < ActiveRecord::Base
  attr_accessible :summary, :title, :cover
  before_create :create_slug


  # relationships (and anonymous modules)
  has_many :story_element_relationships, :dependent => :destroy
  has_many :elements, :through => :story_element_relationships, :foreign_key  => :story_id do
    def create(*data)
      element = Element.create(data)
      proxy_owner.fork(element)
      return element
    end # create
  end # has_many
  belongs_to :author, :class_name => "User", :foreign_key => :owner_id
  has_many :chapters do
    def create(*data)
      chapter = Chapter.new(data)
      chapter.owner_id = proxy_owner.owner_id
      chapter.story_id = proxy_owner.id
      chapter.save
      return chapter
    end # create
  end # has_many
  
  # validations
  validates :title, :presence => true  
  
  # Attachments (be sure to change these for S3 environment in production)
  has_attached_file :cover, :styles => { :small => "50x50>" } ,
    :url => "/images/stories/:id/:style/:basename.:extension" ,
    :path => ":rails_root/public/images/stories/:id/:style/:basename.:extension"
  validates_attachment_size :cover, :less_than => 5.megabytes
  validates_attachment_content_type :cover, :content_type => ['image/png', 'image/gif', 'image/jpg']
  
  # fork an element
  def fork(element)
    begin
      self.author.fork(element)
      a = StoryElementRelationship.create!(:story_id => self.id, :element_id => element.id)
      return a
    rescue
      return nil
    end # begin-rescue
  end # fork

   #slug stuff
    def to_param
      slug
    end

    def create_slug
      self.slug = self.title.parameterize
    end


end # Story





# == Schema Information
#
# Table name: stories
#
#  id                 :integer(4)      not null, primary key
#  owner_id           :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  title              :string(255)     default("Untitled")
#  summary            :string(255)     default("Unwritten")
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer(4)
#  cover_updated_at   :datetime
#  slug               :string(255)
#

