class Story < ActiveRecord::Base
  attr_accessible :summary, :title
  
  # relationships (and anonymous modules)
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
  
  validates :title, :presence => true  
end



# == Schema Information
#
# Table name: stories
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)     default("Untitled")
#  summary    :string(255)     default("Unwritten")
#

