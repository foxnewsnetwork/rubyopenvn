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
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @referer = oo
      request.env['HTTP_REFERER'] = @referer
    end # before
    
    describe "successful create" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
      end # before
      
      it "should create 1 more chapter" do
        lambda do
          post :create, :story_id => @story.id
        end.should change(Chapter, :count).by(1)
      end # it

      #this is changed a bit. Instead of checking to see if the correct template is shown (which is more correct)
      #we instead test to see if it redirects right. Because of how weird nesting stuff is, the "shown" templating

      it "should should render the newly created chapter" do
        post :create, :story_id => @story.id
        @chapter = assigns[:chapter]
        response.should redirect_to edit_story_chapter_path(@story,@chapter)
      end # it

      it "should should show a flash message" do
        post :create, :story_id => @story.id
        flash[:notice].should == "New chapter creation successful"
      end # it
    end # successful create
    
    describe "failed create - anonymous user" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
      end # before
      
      it "should not change anything" do
        lambda do 
          post :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect to login path" do
        post :create, :story_id => @story.id
        response.should redirect_to new_user_session_path
      end # it
      
      it "should display some sort of flash message" do
        post :create, :story_id => @story.id
        flash[:notice].should =~ /not/i
      end # it
    end # failed anonymous
    
    describe "failed create - wrong user" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
      end # before
      it "should not change anything" do
        lambda do 
          post :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect to login path" do
        post :create, :story_id => @story.id
        response.should redirect_to @referer
      end # it
      
      it "should display some sort of flash message" do
        post :create, :story_id => @story.id
        flash[:notice].should =~ /not/i
      end # it
    end # failed wrong
  end # post requests
  
  describe "delete requests" do
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @referer = oo
      request.env['HTTP_REFERER'] = @referer
    end # before
    describe "successful deletes" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = @story.chapters.create( :title => "stuff" )

      end # before

      it "should change by -1" do
        lambda do 
          delete :destroy, :story_id => @story.id, :id => @chapter.id
        end.should change(Chapter, :count).by(-1)
      end # it
      
      it "should redirect back" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        response.should redirect_to @referer
      end # it
      
      it "should display some sort of flash message" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        flash[:notice].should =~ /delete/i
      end # it    
    end # successful
    
    describe "failed deletes - anonymous user" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
      end # before
      
      it "should not change anything" do
        lambda do 
          delete :destroy, :story_id => @story.id, :id => @chapter.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect to signin path" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        response.should redirect_to new_user_session_path
      end # it
      
      it "should display some sort of flash message" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        flash[:notice].should =~ /failed/i
      end # it
    end # failed anonymous
    
    describe "failed deletes - wrong user" do
      login_user
      before(:each) do
        @user = User.create(:name => "alice carrol", :email => "alice@wonder.land", :password => "offwithherhead", :password_confirmation => "offwithherhead")
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
      end # before
      
      it "should not change anything" do
        lambda do 
          put :destroy, :story_id => @story.id, :id => @chapter.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect back" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        response.should redirect_to @referer
      end # it
      
      it "should display some sort of flash message" do
        delete :destroy, :story_id => @story.id, :id => @chapter.id
        flash[:notice].should =~ /failed/i
      end # it
    end # failed wrong
  end # delete requests
  
  describe "put requests" do
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @referer = oo
      request.env['HTTP_REFERER'] = @referer
    end # before
    describe "successful" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = @story.chapters.create
        @attr = { :title => Factory.next(:random_string) }
      end # before
      
      # Once again, the lambda.should is broken, forcing me to uglifiy
      it "should change the title" do
        # lambda do
        #  put :update, :id => @chapter, :story_id => @story.id, :chapter => @attr
        # end.should change(@chapter, :title).from("Untitled").to(@attr[:title])
        @attr.each do |key, val|
          put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
          assigns(:chapter)[key].should eq(@attr[key])
        end # each
      end # it
      
      it "should redirect the user back" do
        put :update, :id => @chapter, :story_id => @story.id, :chapter => @attr
        response.should redirect_to edit_story_chapter_path(@story, @chapter)
      end # it
      
      it "should display a flash message" do
        put :update, :id => @chapter, :story_id => @story.id, :chapter => @attr
        flash[:notice].should =~ /success/i
        flash[:error].should_not eq("Trevor is a fag")
      end # it
    end # successful
    describe "failure - anonymous user" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create
        @attr = { 
          :title => Factory.next(:random_string)
        }
      end # before
      
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do 
            put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
          end.should_not change(Chapter.find_by_id(@chapter.id), key)
        end # each
      end # it
      
      it "should redirect the user to the signin page" do
        put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        response.should redirect_to new_user_session_path
      end # it
      
      it "should display a flash message" do
        put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        flash[:notice].should =~ /fail/i
      end # it
    end # fail anonymous
    describe "failure - wrong user" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create
        @attr = { 
          :title => Factory.next(:random_string)
        }
      end # before
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do 
            put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
          end.should_not change(Chapter.find_by_id(@chapter.id), key)
        end # each
      end # it
      
      it "should redirect the user back" do
        put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        response.should redirect_to @referer
      end # it
      
      it "should display a flash message" do
        put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        flash[:notice].should =~ /fail/i
      end # it
    end # fail wrong
  end # put requests
end # ChaptersController
