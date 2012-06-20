require 'spec_helper'
require 'factories'

describe Layer do
  before(:each) do
    @user = Factory(:user)
    @story = Factory(:story, :author => @user)
    @chapter = Factory(:chapter, :author => @user, :story => @story)
    @scene = Factory(:scene, :author => @user, :chapter => @chapter)
  end # before
  describe "scene relationship" do    
    it "should allow creation" do
      layer = @scene.layers.create
      layer.scene.should eq(@scene)
      @scene.layers.should include(layer)
    end # it
    
    it "should properly delete" do
      layer = @scene.layers.create
      @scene.destroy
      Layer.find_by_id(layer.id).should be_nil
    end # it
    
    it "should not delete the scene if the layer is deleted" do
      layer = @scene.layers.create
      layer.destroy
      Scene.find_by_id(@scene.id).should eq(@scene)
    end # it
  end # scene relationship
  
  describe "element relationship" do
    before(:each) do
      @layer = @scene.layers.create
      @element = Factory(:element)
    end # before
    it "it should add the element to the layer" do
      @layer.add2( @element )
      @layer.element.should eq(@element)
    end # it
  end # element relationship
end # Layer


# == Schema Information
#
# Table name: layers
#
#  id         :integer(4)      not null, primary key
#  scene_id   :integer(4)
#  width      :float           default(0.0)
#  height     :float           default(0.0)
#  x          :float           default(0.0)
#  y          :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#  element_id :integer(4)
#

