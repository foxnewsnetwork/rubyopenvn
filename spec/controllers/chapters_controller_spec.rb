require 'spec_helper'
require 'factories'

describe ChaptersController do
  render_views
  describe "Get requests" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = @story.chapters.create!( :title => "Test chapter" )
    end # before
    describe "get 'show'" do
      it "should be successful" do
        get 'show', :story_id => @story.id, :id => @chapter.id
        response.should be_success
      end # it
    end # Get show  
    describe "get 'edit'" do
      it "should be successful" do
        get 'edit', :story_id => @story.id, :id => @chapter.id
        response.should be_success
      end # it
    end # Get edit
    describe "get 'index'" do
      it "should be successful" do
        get 'index', :story_id => @story.id
        response.should be_success
      end # it
    end # Get index
  end # Get requests
  
  describe "post requests" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
    end # before
    
    describe "successful create" do
      it "should create 1 more chapter" do
        lambda do
          post :create, :story_id => @story.id, :login => @user
        end.should change(Chapter, :count).by(1)
      end # it
      it "should should render the newly created chapter" do
        post :create, :story_id => @story.id, :login => @user
        chapter = assigns(:chapter)
        response.should render chapter
      end # it
      it "should should show a flash message" do
        post :create, :story_id => @story.id, :login => @user
        flash[:notice].should =~ /created/i        
      end # it
    end # successful create
    
    describe "failed create" do
      it "should not change anything" do
        lambda do 
          post :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect to login path" do
        post :create, :story_id => @story.id
        response.should redirect_to new_user_sessions_path
      end # it
      
      it "should display some sort of flash message" do
        post :create, :story_id => @story.id
        flash[:notice].should =~ /not/i
      end # it
    end # failed create
  end # post requests
  
  describe "delete requests" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = @story.chapters.create( :title => "stuff" )
    end # before
    describe "successful deletes" do
      it "should change by -1" do
        lambda do 
          delete :destroy, :story_id => @story.id, :id => @chapter.id, :login => @user
        end.should change(Chapter, :count).by(-1)
      end # it
      
      it "should redirect back" do
        request.env['HTTP_REFERER'] = root_path
        delete :destroy, :story_id => @story.id, :id => @chapter.id, :login => @user
        response.should redirect_to :back
      end # it
      
      it "should display some sort of flash message" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id, :login => @user
        flash[:notice].should =~ /delete/i
      end # it    
    end # successful
    describe "failed deletes" do
      it "should not change anything" do
        lambda do 
          delete :destroy, :story_id => @story.id, :id => @chapter.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect back" do
        request.env['HTTP_REFERER'] = root_path
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        response.should redirect_to :back
      end # it
      
      it "should display some sort of flash message" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        flash[:notice].should =~ /failed/i
      end # it
    end # failed
  end # delete requests
end # ChaptersController
