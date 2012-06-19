require 'spec_helper'

describe Story do
  describe "Story creation" do
    before(:each) do 
      @user = User.create( 
        :name => "test user", 
        :email => "test@test.com", 
        :password => "1234567" 
      ) # end @user
    end # end before
    
    it "users create stories" do
      @root = @user.stories.create(
        :title => "Test Story" ,
        :summary => "Test summary here"
      ) # end @story
      @user.stories.should include(@root)
    end # end it
    
    it "should let an user pull out of of his stories" do
    	@s1 = @user.stories.create( :title => "story 1" )
    	@s2 = @user.stories.create( :title => "story 2" )
    	@s3 = @user.stories.create( :title => "story 3" )
    	@user.stories.should include(@s1, @s2, @s3)
    end # it
  end # story creation
  describe "chapter association" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
    end # before
    
    it "should create a child chapter" do
      @chapter = @story.chapters.create
      @chapter.should_not be_nil
    end # it
    
    it "the child should have the appropriate properties" do
      @chapter = @story.chapters.create
      @chapter.author.should eq(@story.author)
      @chapter.story.should eq(@story)
    end # it
  end # chapter association 
end # end Story





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

