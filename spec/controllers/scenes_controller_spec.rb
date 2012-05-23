require 'spec_helper'
require 'factories'

describe ScenesController do
  render_views
  before(:each) do
    @user = Factory(:user)
    @story = Factory(:story, :author => @user)
    @chapter = @story.chapters.create( :title => "stuff" )
  end # before
  describe "get index" do
    it "should be successful" do
      get 'index', :story => @story.id, :chapter => @chapter.id
      response.should be_success
    end # it
    it "should also do it in ajax" do
      xhr :get, :index, :story => @story.id, :chapter => @chapter.id
      response.should render_template("scenes/index.js.erb")
    end    
  end # get index
  
  describe "successful post" do   
    it "should create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id, :login => @user
      end.should change(Scene, :count).by(1)
    end # it
    
    it "should render the create page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id, :login => @user
      response.should render_template( "scenes/create.js.erb" )
    end # it
  end # successful post
  describe "failed post" do
    it "should not create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      end.should_not change(Scene, :count)
    end # it
    
    it "should render the error page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template( "scenes/error.js.erb" )
    end # it
  end # failed post
  
  describe "put" do
    before(:each) do
      @scene = @chapter.scenes.create
    end # before
    describe "successful" do

    end # successful 
    
    describe "failed" do
      it "should not change anything" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        scene = assigns(:scene)
        scene.should eq(@scene)
      end # it
      
      it "should render the error flash message" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        response.should render_template( "scenes/error.js.erb" )        
      end # it
    end # failed 
  end # put 
  describe "delete" do
    before(:each) do
      @scene = @chapter.scenes.create
    end # before
        
    describe "successful" do
      it "should change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id, :login => @user      
        end.should change(Scene, :count).by(-1)
      end # it
      
      it "should render a flash message" do
        xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id, :login => @user      
        response.should render_template( "scenes/flash.js.erb" )        
      end # it
    end # successful
    
    describe "failed" do
      it "should change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        end.should_not change(Scene, :count)
      end # it
      it "should render the error flash message" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        response.should render_template( "scenes/error.js.erb" )        
      end # it
    end # failed
  end # delete
end # ScenesController
