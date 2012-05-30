require 'spec_helper'
require 'factories'

describe UsersController do
  before(:each) do
    @referer = (0..55).map { |x| ("a".."z").map{ |y| y }[rand(26)] }.join
    request.env['HTTP_REFERER'] = @referer
  end # before
  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe "creates" do
    before(:each) do
      @attr = { :name => "foxnewsnetwork", :password => "1234567", :password_confirmation => "1234567", :email => "foxnewsnetwork@gmail.com" }
    end # before
    describe "successful" do
      it "should change the db" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end # it
      
      it "should redirect to the newly created user page" do
        post :create, :user => @attr
        response.should redirect_to users_path(assigns(:user))
      end # it
      
      it "should display a proper flash message" do
        post :create, :user => @attr
        flash[:notice].should =~ /success/i
      end # it
    end # successful
    
    describe "failed - bad info" do
      before(:each) do
        @existing_user = Factory(:user)
        @attr = { 
          :name => @existing_user.name ,
          :email => @existing_user.email ,
          :password => "Trevor is a faggot"
        }
      end # before
      it "should not create" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end # it
      
      it "should redirect back" do
        request.env['HTTP_REFERER'] = @referer
        post :create, :user => @attr
        response.should redirect_to @referer
      end # it 
      
      it "should display some flash message" do
        post :create, :user => @attr
        flash[:notice].should =~ /fail/i
      end # it
    end # failed - bad info
    
    describe "failed - logged in" do 
      login_user
      before(:each) do
        @attr = { 
          :name => Factory.next(:name) ,
          :email => Factory.next(:email) ,
          :password => "Trevor is a faggot"
        }
      end # before
      it "should not create" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end # it
      
      it "should redirect back" do
        request.env['HTTP_REFERER'] = @referer
        post :create, :user => @attr
        response.should redirect_to @referer
      end # it 
      
      it "should display some flash message" do
        post :create, :user => @attr
        flash[:notice].should =~ /fail/i
      end # it
    end # failed - logged in
  end # create
  
  describe "updates" do
    before(:each) do
      @attr = { 
        :name => Factory.next(:name) ,
        :email => Factory.next(:email)
      }
    end # before
    describe "successful" do
      login_user
      it "should allow for updates" do
        @attr.each do |key, val|
          lambda do
            put :update, :id => @current_user.id, :user => @attr
          end.should change( User.find(@current_user), key).from(@current_user[key]).to(val)
        end # each
      end # it
      it "should redirect to the user show page" do
        put :update, :id => @current_user.id, :user => @attr
        response.should redirect_to users_path(@current_user)
      end # it
    end # describe
    
    describe "failure - anonymous" do
      before(:each) do
        @user = Factory(:user)
      end # before
      
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do
            put :update, :id => @user.id, :user => @attr
          end.should_not change(User.find(@user), key)
        end # each
      end # it
      
      it "should redirect to the signin page" do
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to new_user_session_path
      end # it
    end # failure - anonymous 
    
    describe "failure - wrong" do
      login_user
      before(:each) do
        @user = Factory(:user)
      end # before
      it "should not change anything" do
        @attr.each do |key, val|
          lambda do
            put :update, :id => @user.id, :user => @attr
          end.should_not change(User.find(@user), key)
        end # each
      end # it
      it "should redirect back" do
        request.env['HTTP_REFERER'] = @referer
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to @referer
      end # it
    end # failure - wrong
  end # describe updates
  describe "destroy" do
    login_user
    describe "successful" do
      it "should change the db" do
        lambda do
          delete :destroy, :id => @current_user.id
        end.should change(User, :count).by(-1)
      end # it
      
      it "should redirect to root" do
        delete :destroy, :id => @current_user.id
        response.should redirect_to root_path
      end # it
      
      it "should display a proper flash message" do
        delete :destroy, :id => @current_user.id
        flash[:notice].should =~ /success/i
      end # it
    end # successful
    
    describe "failed - anonymous" do
      before(:each) do
        @user = Factory(:user)
      end # before
      it "should not destroy" do
        lambda do
          delete :destroy, :id => @user.id
        end.should_not change(User, :count)
      end # it
      
      it "should redirect back" do
        request.env['HTTP_REFERER'] = @referer
        delete :destroy, :id => @user.id
        response.should redirect_to @referer
      end # it 
      
      it "should display some flash message" do
        delete :destroy, :id => @user.id
        flash[:notice].should =~ /fail/i
      end # it
    end # failed - anonymous
    
    describe "failed - wrong user" do 
      login_user
      before(:each) do
        @user = Factory(:user)
      end # before
      it "should not destroy" do
        lambda do
          delete :destroy, :id => @user.id
        end.should_not change(User, :count)
      end # it
      
      it "should redirect back" do
        
        delete :destroy, :id => @user.id
        response.should redirect_to @referer
      end # it 
      
      it "should display some flash message" do
        delete :destroy, :id => @user.id
        flash[:notice].should =~ /fail/i
      end # it
    end # failed - wrong user
  end # destroy
end # UsersController
