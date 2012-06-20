require 'spec_helper'
require 'factories'

describe Layer do
  before(:each) do
    @user = Factory(:user)
    @story = Factory(:story, :author => @user)
    @chapter = Factory(:chapter, :author => @user, :story => @story)
    @scene = Factory(:scene, :author => @user, :chapter => @chapter)
  end # before
  
  describe "batch creation and updates" do
    before(:each) do
      @elements = (0..9).map { Factory(:element) }
      @layers = (0..59).map { Factory(:layer, :scene => @scene, :element => @elements[rand(10)] ) }
      @layer_attributes = @layers.map do |layer|
        { 
          :id => rand(100) > 80 ? nil : layer.id ,
          :scene_id => layer.scene_id ,
          :element_id => @elements[ rand(10) ].id ,
          :width => rand(365) ,
          :height => rand(365) ,
          :x => rand(365),
          :y => rand(365)
        }
      end # map
    end # before
    
    it "should create when blank and update on duplicate key" do
      blank_count = 0
      old_count = Layer.count
      Layer.batch_import(@layer_attributes)
      @layer_attributes.each do | layer_attribute |
        if layer_attribute[:id].nil?
        	blank_count += 1
        else
          layer = Layer.find_by_id( layer_attribute[:id] )
          layer_attribute.each do |key, val|
          	layer[key].should eq(val)
          end # layer_attribute.each
        end # if
      end # @layer_attributes.each
      Layer.count.should eq( old_count + blank_count )
    end # it
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

