require 'spec_helper'

describe UsersController do

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
  
  describe "New user creation" do
    it "should create a new user and redirect to it" do
      @data = { :name => "foxnewsnetwork", :password => "1234567", :email => "foxnewsnetwork@gmail.com" }
      post :create, @data
      response.should have_selector( "h1", :text => "foxnewsnetwork" ) 
    end # it
    
    it "should not make a user if given crap" do
      @data = { :name => "fjkasdf" }
      post :create, @data
      response.should have_selector( "h2", :text => "failed" )
    end # it
    
   
  end # end new user creation
end
