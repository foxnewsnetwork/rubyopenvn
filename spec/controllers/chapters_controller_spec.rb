require 'spec_helper'
require 'factories'

describe ChaptersController do
  render_views
  describe "GET JSONs - stockpiles" do
    login_user
    before(:each) do
      @story = Factory(:story, :author => @current_user)
      @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      @elements = []
      (0..50).each do |k|
        @elements << Factory(:element)
        @current_user.fork(@elements[k]) if rand(2) == 0
      end # each
    end # before
    it "should displayed all the forked" do
      get "edit", :story_id => @story, :id => @chapter, :format => "json"
      data = MultiJson.load(response.body)
      data["stockpile"].each do |stock|
        @current_user.elements.map { |x| x.id }.should include(stock["id"])
      end # each
    end # it
  end # GET JSONs - stockpile
  describe "GET JSONs" do
    login_user
    before(:each) do
      @story = Factory(:story, :author => @current_user)
      @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      @elements = []
      (0..24).each do |k|
        @elements << Factory(:element)
      end # each
      @scenes = []
      @scene_data = []
      @scenes[0] = @chapter.scenes.create
      (1..rand(29)).each do |k|
        @scenes << @scenes[k-1].spawn
        (0..rand(6)).each do |j|
          scend = @scenes[k].scene_data.create({
            :element_id => @elements[rand(24)].id ,
            :width => rand(355) ,
            :height => rand(355) ,
            :top => rand(355) ,
            :left => rand(355) ,
            :zindex => rand(355) ,
            :dialogue => Factory.next(:random_string)
          })
          @scene_data << scend
          scend.relate({
            :width => rand(355) ,
            :height => rand(355) ,
            :top => rand(355) ,
            :left => rand(355) ,
            :zindex => rand(355) ,
            :parent => @elements[rand(24)],
            :child => @elements[rand(24)]
          })
        end # each j
      end # each k
    end # before
    
    it "should respond with json" do
      get "edit", :story_id => @story, :id => @chapter, :format => "json"
      response.should be_success
    end # it
    it "the json should have the correct keys" do
      get "edit", :story_id => @story, :id => @chapter, :format => "json"
      data = MultiJson.load(response.body)
      data["scenes"].should_not be_nil
      data["scene_data"].should_not be_nil
      data["elements"].should_not be_nil
      data["element_relationships"].should_not be_nil
    end # it
    it "should leave no child behind" do
      get "edit", :story_id => @story, :id => @chapter, :format => "json"
      data = MultiJson.load(response.body)      
      data['scenes'].each do |scene|
        @scenes.map { |s| s.id }.should include(scene["id"])
      end # scenes.each
      data['scene_data'].each do |scenedata|
        @scene_data.map { |sd| sd.id }.should include(scenedata["id"])
      end # scene_data.each
      data['elements'].each do |element|
        @elements.map { |e| e.id }.should include(element["id"])
      end # elements.each
      data['element_relationships'].each do |elemenetrelationship|
        @element_relationships.map { |er| er.id }.should include(elemenetrelationship["id"])
      end # element_relationships.each
    end # it
  end # GET JSONs
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
      describe "success" do
        login_user
        before(:each) do
          @story2 = Factory(:story, :author => @current_user)
          @chapter2 = Factory(:chapter, :author => @current_user, :story => @story2)
        end # before
        it "should be successful" do
          get 'edit', :story_id => @story2.id, :id => @chapter2.id
          response.should redirect_to edit_story_chapter_path(@story2, @chapter2) + "?usertab=chapters"
        end # it
        it "should be successful p2" do
          get 'edit', :story_id => @story2.id, :id => @chapter2.id, :cmd => "jsedit"
          response.should be_success
        end # it
      end # success
      describe "failure - anonymous" do
        it "should redirect to user sign in" do
          get 'edit', :story_id => @story.id, :id => @chapter.id
          response.should redirect_to new_user_session_path
        end # it
      end # failure - anonymous
      describe "failure - wrong" do
        login_user
        it "should redirect to the root path" do
          get 'edit', :story_id => @story.id, :id => @chapter.id
          response.should redirect_to user_path(@current_user)
        end # it
      end # failure - wrong
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
    
    describe "successful spawning" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      end # before
      
      it "should successful create a chapter" do
        lambda do
          post :create, :story_id => @story.id, :chapter => { :parent => @chapter.id }
        end.should change(Chapter, :count).by(1)
      end # it
      
      it "should successful do it in ajax also" do
        lambda do
          xhr :post, :create, :story_id => @story.id, :chapter => { :parent => @chapter.id }
        end.should change(Chapter, :count).by(1)
      end # it
    end # successful spanwing
    
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
        flash[:success].should == "New chapter creation successful"
      end # it
    end # successful create
    
    describe "failed create - anonymous user" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
      end # before
      
      it "should not change anything even with ajax" do
        lambda do
          xhr :post, :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should not change anything" do
        lambda do 
          post :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should redirect to login path" do
        post :create, :story_id => @story.id
        response.should redirect_to new_user_session_path
      end # it
      
      it "should render the flash error page when ajax" do
        xhr :post, :create, :story_id => @story.id
        response.should render_template "errors/flash"
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
      
      it "should not change anything even with ajax" do
        lambda do
          xhr :post, :create, :story_id => @story.id
        end.should_not change(Chapter, :count)
      end # it
      
      it "should render the flash error page when ajax" do
        xhr :post, :create, :story_id => @story.id
        response.should render_template "errors/flash"
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
    describe "successful - file ul" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = @story.chapters.create
        @attr = { 
          :title => Factory.next(:random_string),
          :cover => fixture_file_upload("spec/pics/pic0.png", "image/png")
        }
      end # before
      
      it "should change the database" do
        put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        chapter = assigns(:chapter)
        chapter.cover.url.should_not =~ /missing/i
      end # it
      it "should change the database xhr" do
        xhr :put, :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
        chapter = assigns(:chapter)
        chapter.cover.url.should_not =~ /missing/i
      end # it
    end # successful - file ul
    describe "failure - bad file" do
      before(:each) do
        @types = ['html', 'image', 'xml', 'json', 'bson']
        @formats = ['jpg', 'tiff', 'fag','ass', 'trevor', 'likes','dicks','bmp','text','css','binary','hex']
        @attr = {
          :title => Factory.next(:random_string),
          :cover => fixture_file_upload("spec/pics/pic0.png", @types[rand(@types.length)] + "/" + @formats[rand(@formats.length)])
        }
        @story = Factory(:story, :author => @current_user)
        @chapter = Factory(:chapter, :author => @current_user, :story => @story)
      end # before
      it "should not change the db" do
        @attr.each do |key, value|
          lambda do
            put :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
          end.should_not change(Chapter.find(@chapter), key)
        end # each
      end # it
      it "should not change the db xhr" do
        @attr.each do |key, value|
          lambda do
            xhr :put, :update, :story_id => @story.id, :id => @chapter.id, :chapter => @attr
          end.should_not change(Chapter.find(@chapter), key)
        end # each
      end # it
    end # failure - bad file
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
            put :update,:id =>@chapter, :story_id => @story.id, :chapter => @attr

          end.should_not change(Chapter.find_by_id(@chapter.id), key)
        end # each
      end # it
      
      it "should redirect the user to the signin page" do
        put :update,:id => @chapter, :story_id => @story.id, :chapter => @attr

        response.should redirect_to new_user_session_path
      end # it
      
      it "should display a flash message" do
        put :update, :id => @chapter, :story_id => @story.id, :chapter => @attr
        flash[:error].should =~ /fail/i

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

       #Summary is not yet defined for a chapter. Need to migrate
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do 
            put :update, :id => @chapter, :story_id => @story.id, :chapter => @attr

          end.should_not change(Chapter.find_by_id(@chapter.id), key)
        end # each
      end # it
      
      it "should redirect the user back" do
        put :update,:id => @chapter, :story_id => @story.id, :chapter => @attr
        response.should redirect_to edit_story_chapter_path(@story, @chapter)
      end # it
      
      it "should display a flash message" do
        put :update,:id => @chapter, :story_id => @story.id, :chapter => @attr
        flash[:error].should =~ /fail/i

      end # it
    end # fail wrong
  end # put requests
end # ChaptersController
