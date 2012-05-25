require 'spec_helper'

describe Chapter do
  describe "Creation" do
    before(:each) do
      @user = User.create!( :name => "Test1", :email => "test@test.com", :password => "testtest" )
      @story = @user.stories.create!( :title => "root story", :summary => "nothing" )
    end # end before
    
    it "should create a chapter" do
      @chap = @story.chapters.create( :title => "first chapter" )
      @story.chapters.should include(@chap)
    end # end it
    
    it "should spawn chapters" do
      @chap = @story.chapters.create( :title => "first chapter" )
      @chap2 = @chap.children.create( :title => "chapter 2" )
      @chap2.parent.should eql(@chap)
    end # it
    
    it "should let a story pull out all its chapters" do
      @c1 = @story.chapters.create( :title => "chapter 1" )
      @c2 = @c1.spawn( :title => "chapter 2" )
      @c3 = @c2.spawn( :title => "chapter 3" )
      @story.chapters.should include(@c1, @c2, @c3)
    end # it
  end # end describe
end # chapter


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
#

