require 'spec_helper'

describe Scene do
  describe "Scene creation" do
    before(:each) do
      @user = User.create( :name => "Test1", :email => "test@test.com", :password => "test1234567" )
      @story = @user.stories.create( :title => "root story", :summary => "nothing" )
      @chapter = @story.chapters.create( :title => "test chapter" )
    end # end before
    
    it "should create a scene" do
      @scene = @chapter.scenes.create
      @chapter.scenes.should include(@scene)
    end # end it
    
    it "scenes spawn scenes" do
      @scene = @chapter.scenes.create
      @scene2 = @scene.children.create
      @scene2.parent.should eql(@scene)
    end # it
    
    it "should let a single chapter pull out all its scenes" do 
      @scene = @chapter.scenes.create
      @s2 = @scene.spawn
      @s3 = @s2.spawn
      @s4 = @s3.spawn
      @chapter.scenes.should include(@scene, @s2, @s3, @s4)
    end # it
  end # end describe
end # end Scene

# == Schema Information
#
# Table name: scenes
#
#  id         :integer(4)      not null, primary key
#  chapter_id :integer(4)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

