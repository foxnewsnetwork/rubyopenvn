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
    login_user
    before(:each) do
      @story = Factory(:story, :author => @current_user)
      @chapter = @story.chapters.create( :title => "stuff" )
    end
    it "should create" do
      lambda do
        xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      end.should change(Scene, :count).by(1)
    end # it
    
    it "should render the create page" do
      xhr :post, :create, :story_id => @story.id, :chapter_id => @chapter.id
      response.should render_template( "scenes/create.js.erb" )
    end # it
  end # successful post
  
  describe "failed post" do
    before(:each) do
      @user = Factory(:user)
      @story = Factory(:story, :author => @user)
      @chapter = @story.chapters.create( :title => "stuff" )
    end
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
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @scene = @chapter.scenes.create
        @attr = { 
          # Pending
        }
      end # before
      
      it "should update the scene" do
        # PENDING
      end
      
      it "should render the view" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id, :scene => @attr
        response.should render_template("scenes/update.js.erb")
      end # it
    end # successful 
    
    describe "failed" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @scene = @chapter.scenes.create
        @attr = { 
          # PENDING
        }
      end # before
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do
            xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id, :scene => @attr
          end.should_not change(Scene.find_by_id(@scene.id), key)
        end # each
      end # it
      
      it "should render the error flash message" do
        xhr :put, :update, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        response.should render_template( "scenes/error.js.erb" )        
      end # it
    end # failed 
  end # put 
  describe "delete" do
    describe "successful" do
      login_user
      before(:each) do
        @story = Factory(:story, :author => @current_user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @scene = @chapter.scenes.create
      end # before
      it "should change the db" do
        lambda do
          xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        end.should change(Scene, :count).by(-1)
      end # it
      
      it "should render the destroy view" do
        xhr :delete, :destroy, :story_id => @story.id, :chapter_id => @chapter.id, :scene_id => @scene.id
        response.should render_template( "scenes/destroy.js.erb" )        
      end # it
    end # successful
    
    describe "failed" do
      login_user
      before(:each) do
        @user = Factory(:user)
        @story = Factory(:story, :author => @user)
        @chapter = @story.chapters.create( :title => "stuff" )
        @scene = @chapter.scenes.create
      end # before
      it "should not change the db" do
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
