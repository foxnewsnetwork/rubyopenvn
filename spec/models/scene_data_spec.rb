require 'spec_helper'
require 'factories'

describe SceneData do
  before(:each) do
    @user = Factory(:user)
    @story = Factory(:story, :author => @user)
    @chapter = @story.chapters.create
    @scene = @chapter.scenes.create
  end # before
  describe "creation" do
    it "should allow scenes to create scene data" do
      @scene_data = @scene.scene_data.create
      @scene_data.should_not be_nil
      @scene_data.scene.should eq( @scene )
    end # it
  end # creation
  describe "destroy" do
    before(:each) do
      @scene_data = @scene.scene_data.create
    end # before
    it "should destroy scene_data when the parent scene is gone" do
      @scene.destroy
      SceneData.find_by_id(@scene_data.id).should be_nil 
    end # it
  end # destroy
end # SceneData

# == Schema Information
#
# Table name: scene_data
#
#  id         :integer(4)      not null, primary key
#  scene_id   :integer(4)
#  element_id :integer(4)
#  width      :float           default(0.0)
#  height     :float           default(0.0)
#  left       :float           default(0.0)
#  top        :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

