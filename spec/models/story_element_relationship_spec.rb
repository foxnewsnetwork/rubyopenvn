require 'spec_helper'

describe StoryElementRelationship do
  describe "ownership" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @element = Factory(:element)
    end # before
    
    it "should support the fork command" do
      @story.fork(@element)
      @story.elements.should include(@element)
      @element.stories.should include(@story)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
    
    it "should support a forked_by command" do
      @element.forked_by(@story)
      @story.elements.should include(@element)
      @element.stories.should include(@story)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
  end # ownership
end # StoryElementRelationship

# == Schema Information
#
# Table name: story_element_relationships
#
#  id         :integer(4)      not null, primary key
#  story_id   :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

