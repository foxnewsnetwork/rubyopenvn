require 'spec_helper'

describe UserElementRelationship do
  describe "ownership" do
    before(:each) do
      @user = Factory(:user)
      @element = Factory(:element)
    end # before
    
    it "should support the fork command" do
      @user.fork(@element)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
    
    it "should support a forked_by command" do
      @element.forked_by(@user)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
  end # ownership
  describe "preexistence" do
    before(:each) do
      @current_user = Factory(:user)
      @story = Factory(:story, :author => @current_user)
      @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      @element = Factory(:element)
      @current_user.fork @element
    end # before
    it "should not let user fork again" do
      lambda do
        @current_user.fork(@element)
      end.should_not change(UserElementRelationship, :count)
    end # it
    it "should let stories fork" do
      lambda do
        @story.fork(@element)
      end.should change(StoryElementRelationship, :count).by(1)
    end # it
    it "should let chapters fork" do
      lambda do
        @chapter.fork(@element)
      end.should change(ChapterElementRelationship, :count).by(1)
    end # it
  end # preexistence
end # UserElementRelationship

# == Schema Information
#
# Table name: user_element_relationships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

