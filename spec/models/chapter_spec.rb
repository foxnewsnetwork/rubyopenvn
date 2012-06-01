require 'spec_helper'

describe Chapter do
  describe "Creation" do
    before(:each) do
      @user = User.create!( :name => "Test1", :email => "test@test.com", :password => "testtest" )
      @story = @user.stories.create!( :title => "root story", :summary => "nothing" )
    end # end before
    
    it "should create a chapter" do
      @chap = @story.chapters.create( :title => "first chapter" )
      @story.chapters.should include(@chap)
    end # end it
    
    it "should spawn chapters" do
      @chap = @story.chapters.create( :title => "first chapter" )
      @chap2 = @chap.children.create( :title => "chapter 2" )
      @chap2.parent.should eql(@chap)
    end # it
    
    it "should spawn chapters that correctly reference the parent" do
      @parent = Factory(:chapter, :story => @story, :author => @user)
      @child = @parent.children.create
      @child.author.should eq(@parent.author)
      @child.story.should eq(@parent.story)
      @child.parent.should eq(@parent)
    end # it
    
    it "should spawn children with the spawn function" do
      @parent = Factory(:chapter, :author => @user, :story => @story)
      @child = @parent.spawn
      @child.author.should eq(@parent.author)
      @child.parent.should eq(@parent)
    end # it
    
    it "should let a story pull out all its chapters" do
      @c1 = @story.chapters.create( :title => "chapter 1" )
      @c2 = @c1.spawn( :title => "chapter 2" )
      @c3 = @c2.spawn( :title => "chapter 3" )
      @story.chapters.should include(@c1, @c2, @c3)
    end # it
  end # end describe
  describe "dirty-load" do
    before(:each) do
      # step 1: standard stuff
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = @story.chapters.create
      
      # step 1.5: inbetween
      @elements = []
      (0..29).each do |x|
        @elements << Factory(:element)
      end # each
      
      # Step 2: scenes & relationships
      @scenes = [@chapter.scenes.create( :number => rand(100) )]
      (1..10).each do |x|
        @scenes << @scenes[x-1].spawn
        (0..2).each do |y|
          scene_data = @scenes[x].scene_data.create({
            :width => rand(256),
            :height => rand(256),
            :top => rand(256),
            :left => rand(256) ,
            :zindex => rand(256)
          })
          (0..rand(28)).each do |z|
            scene_data.relate({
              :parent => @elements[z] ,
              :child => @elements[z+1] ,
              :width => rand(256),
              :height => rand(256),
              :top => rand(256),
              :left => rand(256),
              :zindex => rand(256)
            })
          end # each
        end # each
      end # each
    end # before
    it "should at least respond" do
      dirty_json = @chapter.dirty_jsonify
      puts dirty_json
      dirty_json.should_not be_blank
    end # it
  end # dirty-jsonify
end # chapter



# == Schema Information
#
# Table name: chapters
#
#  id         :integer(4)      not null, primary key
#  story_id   :integer(4)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)     default("Untitled")
#  owner_id   :integer(4)
#

