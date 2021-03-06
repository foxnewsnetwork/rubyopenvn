require 'spec_helper'
require 'factories'

describe StoriesController do
  
  describe "metatest" do
    login_user
    it "should pass" do
      post :create
      1.should eq(1)
    end # it
  end # metatest
  
  describe "Get 'show'" do
    render_views
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user )
    end # before
    
    it "should be successful" do
      get 'show', :id => @story.slug
      response.should be_success
    end # it
  end # describe
  
  describe "Get 'index'" do
    render_views
    it "should be successful" do
      get 'index'
      response.should be_success
    end # it
  end # describe
  
  describe "Get 'edit'" do
    render_views
    describe "success" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
      end # before
      it "should redirect to the user-sign-in page" do
        get 'edit', :id => @story
        response.should be_success
      end # it
    end # success
    describe "failure anonymous user" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user )
      end # before
      it "should redirect to the sign-in page" do
        get "edit", :id => @story
        response.should redirect_to new_user_session_path
      end # it
    end # failure-anonymous
    describe "failure wrong user" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user )
      end # before
      it "should redirect back to the show page" do
        get "edit", :id => @story
        response.should redirect_to story_path(@story)
      end # it
      it "should display some sort of flash message" do
        get "edit", :id => @story
        flash[:error].should =~ /can/i
      end # it
    end # failure-wrong
    
  end # describe
  
  describe "Get 'new'" do
    render_views
    describe "success" do
      login_user
      it "should be successful" do
        get "new"
        response.should be_successful
      end # it
    end # success
    describe "failure - anonymous" do
      it "should redirect to the signing page" do
        get "new"
        response.should redirect_to new_user_session_path
      end # it
    end # failure anonymous
  end # describe
  
  describe "post file upload" do
    before(:each) do
      @referer = Factory.next(:random_string)
    end # before
    describe "failure" do
      before(:each) do
        @attr = {
          :title => Factory.next(:random_string) ,
          :summary => Factory.next(:random_string) ,
          :cover => fixture_file_upload("spec/pics/pic0.png", "image/png")
        }
      end # before
      describe "anonymous user" do
        it "should not change anything" do
          lambda do
            post :create, :story => @attr
          end.should_not change(Story, :count)
          
        end # it
      end # anonymous user
      
    end # failure
    describe "success" do
    
    end # success
  end # post upload
  
  describe "failed post 'create'" do
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		@data = (0..50).map{ o[rand(o.length)]  }.join
  		@user = User.create( :name => "test", :password => "1234567", :email => "test@test.test" )
  		@attr = { 
    		:title => @data ,
    		:summary => "Some summary here"
    	}
    end # before
    
    it "should not create a new story" do
      lambda do
        post :create, :story => @attr
      end.should_not change(Story, :count)
    end # it
    
    it "should redirect to an user signin page" do
      post :create, :story => @attr
      response.should redirect_to new_user_session_path
    end # it
    
    it "should leave some sort of flash message" do 
      post :create, :story => @attr
      flash[:error].should =~ /./i
    end # it
  end # describe
  
  describe "successful post 'create'" do
    login_user
  	before(:each) do
  		o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		@data = (0..50).map{ o[rand(o.length)]  }.join
  		@user = User.create( :name => "test", :password => "1234567", :email => "test@test.test" )
  		@attr = { 
    		:title => @data ,
    		:summary => "Some summary here"
    	}
    	@login = { 
    	  :email => "test@test.test" ,
    		:password => "1234567"
  		}  
  	end # end before
    
    
    it "should let an user create a story" do
    	lambda do
      	post :create, :story => @attr
      end.should change(Story, :count).by(1)
    end # it
    
    it "should redirect to the correct story edit page" do
      post :create, :story => @attr
      response.should redirect_to story_path(assigns(:story))
    end # it
    
    it "should leave some sort of flash notice" do
      post :create, :story => @attr
      flash[:success].should =~ /success/i
    end # it
  end # describe
  
  describe "Access control" do
    before(:each) do
      @rid = Random.rand(256)
    end # before
    it "should redirect to the signin page" do
      post :create
      response.should redirect_to new_user_session_path
    end # it
    it "should redirect to the signin page" do
      delete :destroy, :id => @rid
      response.should redirect_to new_user_session_path
    end # it
    it "should redirect to the signin page" do
      put :update, :id => @rid
      response.should redirect_to new_user_session_path
    end # it
  end # Access control
  
  describe "successful put updates" do
    login_user
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @story = Factory(:story, :author => @current_user)
      @attr = { 
        :title => oo ,
        :summary => "changed junk"
      }
      request.env['HTTP_REFERER'] = root_path
    end # before
    
    it "should correctly update the attributes" do
      put :update, :id => @story.id, :story => @attr
      story = assigns(:story)
      story.title.should eq( @attr[:title] )
    end # it
    
    it "should redirect back to the story page" do
      put :update, :id => @story.id, :story => @attr
      response.should redirect_to edit_story_path( @story )
    end # it
    
    it "should display some sort of flash message" do
      put :update, :id => @story.id, :story => @attr
      flash[:notice].should =~ /success/i
    end # it
  end # successful put updates
  
  describe "put file uploads" do
    before(:each) do
      @referer = Factory.next(:random_string)
      request.env['HTTP_REFERER'] = @referer
      @attr = {
        :title => Factory.next(:random_string) ,
        :summary => Factory.next(:random_string),
        :cover => fixture_file_upload("spec/pics/pic1.png", "image/png")
      }
    end # before
    describe "success - no previous" do
      login_user
      before(:each) do
        @story = @current_user.stories.create(:title => Factory.next(:random_string), :summary => Factory.next(:random_string))
      end # before
      it "should update the db" do
        put :update, :id => @story.id, :story => @attr
        story = assigns(:story)
        story.cover.url.should_not =~ /missing/i
      end # it
      it "should update the db when done in xhr" do
        xhr :put, :update, :id => @story.id, :story => @attr
        story = assigns(:story)
        story.cover.url.should_not =~ /missing/i
      end # it
    end # success - no previous
    describe "success - yes previous" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
      end # before
      it "should update the db" do
        old_value = @story.cover.url
        put :update, :id => @story.id, :story => @attr
        story = assigns(:story)
        story.cover.url.should_not eq(old_value)
      end # it
      it "should update the db when done in xhr" do
        old_value = @story.cover.url
        xhr :put, :update, :id => @story.id, :story => @attr
        story = assigns(:story)
        story.cover.url.should_not eq(old_value)
      end # it
    end # success - yes pervious
    describe "failure - wrong user" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
      end # before
      
      it "should not change anything" do
        @attr.each do |key, value|
          lambda do
            put :update, :id => @story.id, :story => @attr
          end.should_not change(Story.find(@story), key)
        end # each
      end # it
      
      it "should not change anything with ajax" do
        @attr.each do |key, value|
          lambda do
            xhr :put, :update, :id => @story.id, :story => @attr
          end.should_not change(Story.find(@story), key)
        end # each
      end # it
    end # failure - wrong
    describe "failure - wrong format" do
      login_user
      before(:each) do
        @types = ['html', 'image', 'xml', 'json', 'bson']
        @formats = ['jpg', 'tiff', 'fag','ass', 'trevor', 'likes','dicks','bmp','text','css','binary','hex']
        @attr[:cover] = fixture_file_upload("spec/pics/pic0.png", @types[rand(@types.length)] + "/" + @formats[rand(@formats.length)])
        @story = Factory(:story, :author => @current_user)
      end # before
      it "should not change anything" do
        @attr.each do |key, value|
          lambda do
            put :update, :id => @story.id, :story => @attr
          end.should_not change(Story.find(@story), key)
        end # each
      end # it
      it "should not change anything xhr" do
        @attr.each do |key, value|
          lambda do
            xhr :put, :update, :id => @story.id, :story => @attr
          end.should_not change(Story.find(@story), key)
        end # each
      end # it 
    end # failure failure - format
  end # describe
  
  describe "failed put updates - access control" do
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @attr = { 
        :title => oo ,
        :summary => "changed junk"
      }
      request.env['HTTP_REFERER'] = root_path
    end # before
    
    it "should not change anything" do
      @attr.each do |key, val|
        lambda do
          put :update, :id => @story.id, :story => @attr
        end.should_not change(Story.find_by_id(@story.id), key)
      end # each
    end # it
    
    it "should redirect to the signin page" do
      put :update, :id => @story.id, :story => @attr
      response.should redirect_to new_user_session_path
    end # it
    
    it "should display some sort of flash message" do
      put :update, :id => @story.id, :story => @attr
      flash[:error].should =~ /failed/i    
    end # it
  end # describe
  
  describe "failed put updates - wrong user" do
    login_user
    before(:each) do
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		oo = (0..50).map{ o[rand(o.length)]  }.join
      @user = User.create(:name => "faggot", :email => "asldkfjalsdf@jfk.com", :password => "3025879257", :password_confirmation => "3025879257" )
      @story = Factory(:story, :author => @user)
      @attr = { 
        :title => oo ,
        :summary => "changed junk"
      }
      request.env['HTTP_REFERER'] = root_path
    end # before
    
    it "should not change anything" do
      put :update, :id => @story.id, :story => @attr
      story = assigns(:story)
      story.title.should_not eq(@attr[:title])
      story.title.should eq(@story.title)
    end # it
    
    it "should redirect back" do
      put :update, :id => @story.id, :story => @attr
      response.should redirect_to edit_story_path(@story)
    end # it
    
    it "should display some sort of flash message" do
      put :update, :id => @story.id, :story => @attr
      flash[:error].should =~ /failed/i    
    end # it
  end # describe
    
  describe "successful delete" do
    login_user
    before(:each) do
      @story = Factory(:story, :author => @current_user)
      request.env['HTTP_REFERER'] = story_path(@story)
    end # before
    
    it "should change kill the story" do
      lambda do
        delete :destroy, :id => @story.id
      end.should change( Story, :count ).by(-1)
    end # it
    
    it "should redirect the user back" do
      delete :destroy, :id => @story.id
      response.should redirect_to story_path(@story)
    end # it
    
    it "should display some sort of flash message" do
      delete :destroy, :id => @story.id
      flash[:notice].should =~ /success/i
    end # it
  end # describe
  
  describe "failed delete - access control" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      request.env['HTTP_REFERER'] = story_path(@story)
    end # before
    
    it "should not do anything" do
      lambda do
        delete :destroy, :id => @story.id
      end.should_not change( Story, :count )
    end # it
    
    it "should redirect the user to the signin page" do
      delete :destroy, :id => @story.id
      response.should redirect_to new_user_session_path
    end # it
    
    it "should display some sort of flash message" do
      delete :destroy, :id => @story.id, :login => @user
      flash[:notice].should =~ /permission/i
    end # it
  end # describe
  
  describe "failed delete - wrong user" do
    login_user
    before(:each) do
      @user = User.create(:name=>"faggot", :email => "alsdf@as.com", :password => "asdfasdfasdf", :password_confirmation=>"asdfsadfsadf")
      @story = Factory(:story, :author => @user)
      request.env['HTTP_REFERER'] = story_path(@story)
    end # before
    
    it "should not do anything" do
      lambda do
        delete :destroy, :id => @story.id
      end.should_not change( Story, :count )
    end # it
    
    it "should redirect back" do
      delete :destroy, :id => @story.id
      response.should redirect_to story_path(@story)
    end # it
    
    it "should display some sort of flash message" do
      delete :destroy, :id => @story.id
      flash[:notice].should =~ /permission/i
    end # it
  end # describe
  
end # describe
