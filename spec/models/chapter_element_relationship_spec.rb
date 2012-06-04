require 'spec_helper'
require 'factories'

describe ChapterElementRelationship do
  describe "ownership" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = Factory(:chapter, :author => @user, :story => @story)
      @element = Factory(:element)
    end # before
    
    it "should support the fork command" do
      @chapter.fork(@element)
      @chapter.elements.should include(@element)
      @element.chapters.should include(@chapter)
      @story.elements.should include(@element)
      @element.stories.should include(@story)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
    
    it "should support a forked_by command" do
      @element.forked_by(@chapter)
      @chapter.elements.should include(@element)
      @element.chapters.should include(@chapter)
      @story.elements.should include(@element)
      @element.stories.should include(@story)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
  end # ownership
end # ChapterElementRelationship

# == Schema Information
#
# Table name: chapter_element_relationships
#
#  id         :integer(4)      not null, primary key
#  chapter_id :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

