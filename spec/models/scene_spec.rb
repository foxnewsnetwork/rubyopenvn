require 'spec_helper'
require 'factories'

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
    
    describe "batch updates" do
      before(:each) do
        @scenes = (0..59).map { Factory(:scene, :author => @user, :chapter => @chapter) }
        @attrs = @scenes.map do |scene|
          { 
            :id => scene.id , # protected
            :parent_id => scene.parent_id,  # protected
            :chapter_id => scene.chapter_id , # protected
            :owner_id => scene.owner_id , #protected
            :texts => Factory.next( :random_string ) , # mass-assigned
            :fork_text => Factory.next( :random_string ), # mass-assigned
            :fork_number => rand(15) # mass-assigned
          } # return
        end # map
      end # before
      
      it "should properly update" do
        Scene.batch_import(@attrs)
        @attrs.each do |scene|
          updated_scene = Scene.find_by_id( scene[:id] )
          updated_scene.should_not be_nil
          scene.each do |key, val|
            updated_scene[key].should eq(val)
          end # scene.each
        end # @attrs.each
      end # it
    end # batch creation
  end # end describe
  
end # end Scene





# == Schema Information
#
# Table name: scenes
#
#  id          :integer(4)      not null, primary key
#  chapter_id  :integer(4)
#  parent_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  number      :integer(4)
#  owner_id    :integer(4)
#  fork_text   :string(255)
#  fork_number :integer(4)      default(0)
#  texts       :text
#

