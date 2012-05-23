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
  
end # end Story


# == Schema Information
#
# Table name: stories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  owner_id   :integer(4)
#  summary    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

