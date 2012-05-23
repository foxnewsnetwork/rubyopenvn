require 'spec_helper'
require 'factories'

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
      @data = { :name => "foxnewsnetwork", :password => "1234567", :password_confirmation => "1234567", :email => "foxnewsnetwork@gmail.com" }
      post :create, @data
      response.should have_selector( "h1", :text => "foxnewsnetwork" ) 
      User.find( :name => "foxnewsnetwork" ).should exist
    end # it
    
    it "should not make a user if missing junk" do
      @data = { :name => "fjkasdf" }
      post :create, @data
      response.should have_selector( "h2", :text => "failed" )
      User.find( :name => "fjkasdf" ).should_not exist
    end # it
    
  end # end new user creation
  
  describe "updates" do
  	before(:each) do
  		@attr = { 
  			:name => "test",
  			:password => "1234567" ,
  			:password_confirmation => "1234567" ,
  			:email => " test@test.test"
  		}
  		@user = User.create!(@attr)
  	end # before
  	
  	it "should update user attributes" do
  		o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  		data = (0..50).map{ o[rand(o.length)]  }.join
  		put :update, { :name => data }
  		response.should have_selector( "h2", :content => data )
  		@user.name.should eq( data )
  	end # it
  end # describe updates
end
