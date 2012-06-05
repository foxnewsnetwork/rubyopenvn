require 'spec_helper'
require 'factories'

describe ChapterElementRelationship do
  describe "destructions" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = Factory(:chapter, :author => @user, :story => @story)
      @element = Factory(:element)
      @chapter.fork(@element)
    end # before
    
    it "should destroy the relationship is the element is removed" do
      lambda do
        @element.destroy
      end.should change(ChapterElementRelationship, :count).by(-1)
    end # it
    
    it "should  destroy the relationships if the chapter is removed" do
      lambda do
        @chapter.destroy
      end.should change(ChapterElementRelationship, :count).by(-1)
    end # it
    
    it "should update the relationships" do
      element = @element.destroy
      @chapter.elements.should_not include(element)
    end # it
    
    it "should update the reverse relationship" do
      chapter = @chapter.destroy
      @element.chapters.should_not include(chapter)
    end # it
  end # destructions
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
  describe "preexistence" do
    before(:each) do
      @current_user = Factory(:user)
      @story = Factory(:story, :author => @current_user)
      @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      @element = Factory(:element)
      @chapter.fork @element
    end # before
    it "should not let user fork again" do
      lambda do
        @current_user.fork(@element)
      end.should_not change(UserElementRelationship, :count)
    end # it
    it "should not let stories fork" do
      lambda do
        @story.fork(@element)
      end.should_not change(StoryElementRelationship, :count)
    end # it
    it "should not let chapters fork" do
      lambda do
        @chapter.fork(@element)
      end.should_not change(ChapterElementRelationship, :count)
    end # it
  end # preexistence
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

