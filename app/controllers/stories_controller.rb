class StoriesController < ApplicationController
  
  ######
  # Get Section
  ######
  def show
    
  end
  
  def new
  
  end
  
  def edit
  
  end
  
  def index
  
  end
  
  ######
  # Post Section
  ######
  def create
  	# Step 0: To facilitate tests, we allow on-spot signin
  	unless params[:login].nil?
  		if params[:login][:email] && params[:login][:password]
				@user = User.authenticate( params[:login] )
				sign_in(@user) unless @user.nil?
  		end # if
  	end # if
  
    # Step 1: Confirm logged in user
    if user_signed_in?
    	@story = current_user.stories.new(params[:story])
    	success_flag = @story.save
    	flash[:notice] = success_flag ? "Story successfully created" : "Story creation failled"
    	respond_to do |format|
    		format.js
    		format.html do
    			render "stories/show" if success_flag
    			redirect_to new_story_path unless success_flag
    		end # format.html
    	end # respond_to
    else
    	flash[:error] = "You must be logged in to write stories"
      respond_to do |format|
        format.js do
        	render "errors/flash.js.erb"
        end # format.js
        format.html do
        	redirect_to new_user_session_path
       	end # format.html
      end # respond_to
    end # if
  end # create
  
  ######
  # Put Section
  ######
  def update
  
  end
  
  ######
  # Delete Section
  ######
  def destroy
  
  end
end # StoriesController
