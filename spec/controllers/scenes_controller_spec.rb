require 'spec_helper'
require 'factories'

describe ScenesController do
  render_views
  before(:each) do
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    oo = (0..50).map{ o[rand(o.length)]  }.join
    @referer = oo
    request.env['HTTP_REFERER'] = @referer
  end # before
  describe "get index" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = @story.chapters.create(:title => "Scenes controller test")
      @scene = @chapter.scenes.create
    end # before
    it "should be successful" do
      get 'index', :story_id => @story.id, :chapter_id => @chapter.id
      response.should be_success
    end # it
    it "should also do it in ajax" do
      xhr :get, :index, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template("scenes/index")
    end    
  end # get index
  
  describe "successful post" do   
    login_user
    before(:each) do
      @story = Factory(:story, :author => @current_user)
      @chapter = Factory(:chapter, :author => @current_user, :story => @story)
    end # before
    it "should create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      end.should change(Scene, :count).by(1)
    end # it
    
    it "should render the create page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template( "scenes/create" )
    end # it
  end # successful post
  
  describe "failed post - anonymous" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = Factory(:chapter, :author => @user, :story => @story)
    end
    it "should not create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      end.should_not change(Scene, :count)
    end # it
    
    it "should render the error page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template( "errors/flash" )
    end # it
  end # failed post
  
  describe "failed post - wrong" do
    login_user
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = Factory(:chapter, :author => @user, :story => @story)
    end
    it "should not create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      end.should_not change(Scene, :count)
    end # it
    
    it "should render the error page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template( "errors/flash" )
    end # it
  end # failed post
  
  describe "put" do
    describe "successful" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @current_user)
        @chapter = Factory(:chapter, :author => @current_user, :story => @story)
        @scene = Factory(:scene, :author => @current_user, :chapter => @chapter)
        @attr = { :number => rand(56) }
      end # before
      
      # ATTN: This test won't pass for some reason. 3 cheers for whoever can get it to pass
      # Since we're only testing numbers, might as well hardcode the test
      # if that attribute updates then all other attributes would change if added.
      # if it is a weird special attribute we'll just need another test'
      it "should update the scene" do

        #Unelegant as hell but it works. It tests the same thing as the previous test.
        old_number = @scene.number
        @scene.number.should_not == @attr[:number]
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id, :scene => @attr
        @changed_scene = Scene.find(@scene.id)
        @changed_scene.number.should == @attr[:number]
        @changed_scene.number.should_not == old_number


      end # it
      
      it "should render the view" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id, :scene => @attr
        response.should render_template("scenes/update")
      end # it
    end # successful 
    
    describe "failed - wrong" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = Factory(:chapter, :author => @user, :story => @story)
        @scene = Factory(:scene, :author => @user, :chapter => @chapter)
        @attr = { :number => rand(56) }
      end # before
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do
            xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id, :scene => @attr
          end.should_not change(Scene.find_by_id(@scene.id), key)
          
        end # each
      end # it
      it "should render the error flash message" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        response.should render_template( "errors/flash" )        
      end # it
    end # failed - wrong
    describe "failed - anonymous" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = Factory(:chapter, :author => @user, :story => @story)
        @scene = Factory(:scene, :author => @user, :chapter => @chapter)
        @attr = { :number => rand(56) }
      end # before
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do
            xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id, :scene => @attr
          end.should_not change(Scene.find_by_id(@scene.id), key)
          
        end # each
      end # it
      it "should render the error flash message" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        response.should render_template( "errors/flash" )        
      end # it
    end # failed - anonymous
  end # put 
  describe "delete" do
    describe "successful" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = Factory(:chapter, :author => @current_user, :story => @story)
        @scene = Factory(:scene, :author => @current_user, :chapter => @chapter)
      end # before
      
      it "should change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        end.should change(Scene, :count).by(-1)
      end # it
      
      it "should render the destroy view" do
        xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        response.should render_template( "scenes/destroy" )        
      end # it
    end # successful
    
    describe "failed - wrong" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @chapter.author = @user
        @chapter.save
        @scene = @chapter.scenes.create
        @scene.author = @user
        @scene.save
      end # before
      it "should not change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        end.should_not change(Scene, :count)
      end # it
      it "should render the error flash message" do
        xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        response.should render_template( "errors/flash" )        
      end # it
    end # failed
    describe "failed - anonymous" do
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @chapter.author = @user
        @chapter.save
        @scene = @chapter.scenes.create
        @scene.author = @user
        @scene.save
      end # before
      it "should not change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        end.should_not change(Scene, :count)
      end # it
      it "should render the error flash message" do
        xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :id => @scene.id
        response.should render_template( "errors/flash" )        
      end # it
    end # failed - anonymous
  end # delete
end # ScenesController
