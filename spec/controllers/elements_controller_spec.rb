require 'spec_helper'
require 'factories'

describe ElementsController do
  include ActionDispatch::TestProcess
  before(:each) do
    @referer = Factory.next(:random_string)
    request.env['HTTP_REFERER'] = @referer
    @image = fixture_file_upload(Rails.root + 'spec/pics/pic0.png', "image/png")
  end # before
  describe "create" do
    before(:each) do
      @attr = { :metadata => Factory.next(:random_string), :picture => @image }
    end # before
    describe "failure - anonymous" do
      it "should not change anything in elements" do
        lambda do 
          post :create, :element => @attr
        end.should_not change(Element, :count)
      end # it
      it "should not change anything in elements relationships" do
        lambda do 
          post :create, :element => @attr
        end.should_not change(UserElementRelationship, :count)
      end # it
      it "should redirect to the user sign_in page" do
        post :create, :element => @attr
        response.should redirect_to new_user_session_path
      end # it
      it "should have a flash message" do
        post :create, :element => @attr
        flash[:notice].should =~ /in/i
      end # it
    end # failure - anonymous
    
    describe "failure - wrong user" do
      login_user 
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = Factory(:chapter, :author => @user, :story => @story)
        @attr = { :metadata => Factory.next(:random_string), :picture => @image }
      end # before
      it "should still create" do
        lambda do
          post :create, :story_id => @story.id, :chapter_id => @chapter.id, :element => @attr
        end.should change(Element, :count).by(1)
      end # it
      it "should still feature good relations" do
        post :create, :story_id => @story.id, :chapter_id => @chapter.id, :element => @attr
        element = assigns(:element)
        @current_user.elements.should include(element)
        element.users.should include(@current_user)
        @user.elements.should_not include(element)
        element.users.should_not include(@user)
        @story.elements.should_not include(element)
        element.stories.should_not include(@story)
        @chapter.elements.should_not include(element)
        element.chapters.should_not include(@chapter)
      end # it
      it "should display an appropriate flash message" do
        post :create, :story_id => @story.id, :chapter_id => @chapter.id, :element => @attr
        flash[:notice].should =~ /are/i
      end # it
      it "should redirect back" do
        post :create, :story_id => @story.id, :chapter_id => @chapter.id, :element => @attr
        response.should redirect_to @referer
      end # it
    end # failure - wrong user
    describe "failure - bad data" do
      login_user
      before(:each) do
        @attr2 = { :metadata => Factory.next(:random_string) }
      end # before
      it "should not change anything in elements" do
        lambda do 
          post :create, :element => @attr2
        end.should_not change(Element, :count)
      end # it
      it "should not change anything in elements relationships" do
        lambda do 
          post :create, :element => @attr2
        end.should_not change(UserElementRelationship, :count)
      end # it
      it "should have a flash message" do
        post :create, :element => @attr2
        flash[:notice].should =~ /fail/i
      end # it
      it "should redirect back" do
        post :create, :element => @attr2
        response.should redirect_to @referer
      end # it
    end # failure - bad data
    describe "success - user deep" do
      login_user
      before(:each) do
        @attr = { :metadata => Factory.next(:random_string), :picture => @image }
      end # before
      it "should have the correct relations" do
        post :create, :element => @attr
        element = assigns(:element)
        @current_user.elements.should include(element)
        element.users.should include(@current_user)
      end # it (yes, I know this hits the model)
      it "should create a new element" do
        lambda do
          post :create, :element => @attr
        end.should change(Element, :count).by(1)
      end # it
      it "should create a new user element relationship" do
        lambda do
          post :create, :element => @attr
        end.should change(UserElementRelationship, :count).by(1)
      end # it
      it "should redirect back" do
        post :create, :element => @attr
        response.should redirect_to @referer
      end # it
      it "should have a flash message" do
        post :create, :element => @attr
        flash[:success].should =~ /success/i
      end # it
    end # success- user deep
    describe "success - story deep" do
      login_user
      before(:each) do
        @attr = { :metadata => Factory.next(:random_string), :picture => @image }
        @story = Factory(:story, :author => @current_user)
      end # before
      it "should have the correct relations" do
        post :create, :story_id => @story, :element => @attr
        element = assigns(:element)
        @current_user.elements.should include(element)
        element.users.should include(@current_user)
        @story.elements.should include(element)
        element.stories.should include(@story)
      end # it (yes, I know this hits the model)
      it "should create a new element" do
        lambda do
          post :create, :story_id => @story, :element => @attr
        end.should change(Element, :count).by(1)
      end # it
      it "should create a new user element relationship" do
        lambda do
          post :create, :story_id => @story, :element => @attr
        end.should change(UserElementRelationship, :count).by(1)
      end # it
      it "should create a new story element relationship" do
        lambda do
          post :create, :story_id => @story, :element => @attr
        end.should change(StoryElementRelationship, :count).by(1)
      end # it
      it "should redirect back" do
        post :create, :story_id => @story, :element => @attr
        response.should redirect_to @referer
      end # it
      it "should have a flash message" do
        post :create, :story_id => @story, :element => @attr
        flash[:success].should =~ /success/i
      end # it
    end # success - story deep
    describe "success - chapter deep" do
      login_user
      before(:each) do
        @attr = { :metadata => Factory.next(:random_string), :picture => @image }
        @story = Factory(:story, :author => @current_user)
        @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      end # before
      it "should have the correct relations" do
        post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        element = assigns(:element)
        @current_user.elements.should include(element)
        element.users.should include(@current_user)
        @story.elements.should include(element)
        element.stories.should include(@story)
        @chapter.elements.should include(element)
        element.chapters.should include(@chapter)
      end # it (yes, I know this hits the model)
      it "should create a new element" do
        lambda do
          post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        end.should change(Element, :count).by(1)
      end # it
      it "should create a new user element relationship" do
        lambda do
          post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        end.should change(UserElementRelationship, :count).by(1)
      end # it
      it "should create a new story element relationship" do
        lambda do
          post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        end.should change(StoryElementRelationship, :count).by(1)
      end # it
      it "should create a new chapter element relationship" do
        lambda do
          post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        end.should change(ChapterElementRelationship, :count).by(1)
      end # it
      it "should redirect back" do
        post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        response.should redirect_to @referer
      end # it
      it "should have a flash message" do
        post :create, :story_id => @story, :chapter_id => @chapter, :element => @attr
        flash[:success].should =~ /success/i
      end # it
    end # success - chapter deep
  end # post
  
  describe "destroy" do
    describe "success" do
      pending "Not implemented yet"
    end # success
    describe "failure - not-admin" do
      pending "Not implemented yet"
    end # failure - not-admin
    describe "failure - anonymous" do
      before(:each) do
        @element = Factory(:element)
      end # before
      it "should not change anything" do
        lambda do
          delete :destroy, :id => @element.id
        end.should_not change(Element, :count)
      end # it
      it "should not change anything (xhr)" do
        lambda do
          xhr :delete, :destroy, :id => @element.id
        end.should_not change(Element, :count)
      end # it
      it "should redirect to the login page" do
        delete :destroy, :id => @element.id
        response.should redirect_to new_user_session_path
      end # it
    end # failure - anonymous
  end # destroy
  
  describe "update" do
    pending "Not written yet"
  end # update

end # ElementsController
