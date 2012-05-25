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
    	flash[:notice] = success_flag ? "Story successfully created" : "Story creation failled; blank"
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
    if user_signed_in?
      @story = Story.find_by_id( params[:id] )
      if current_user.id == @story.owner_id
        @story.update_attributes( params[:story] )
        flash[:notice] = "Successfully updated story attributes"
      else
        flash[:error] = "Failed because you should not be making anonymous changes to people's stories"
      end # if
      respond_to do |format|
        format.js
        format.html { redirect_to story_path(@story) }
      end # respond_to
    else
      flash[:error] = "Failed because you should not be making anonymous changes to people's stories"
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to new_user_session_path }
      end # respond_to
    end # if
  end # update
  
  ######
  # Delete Section
  ######
  def destroy
    unless user_signed_in?
      flash[:notice] = "You do not have permission to delete works if you're not signed in."
      respond_to do |format|
        format.js { 
          render "errors/flash.js.erb" 
          redirect_to new_user_session_path
        }
        format.html { redirect_to new_user_session_path }
      end # respond_to
      return
    end # unless
    @story = Story.find_by_id(params[:id])
    if @story.owner_id == current_user.id
      @story.delete
      flash[:notice] = "Story successfully deleted."
    else
      flash[:notice] = "You do not have permission to delete works if you're not signed in."
    end # if
    respond_to do |format|
      format.js 
      format.html { redirect_to :back }
    end # respond_to
  end # destroy
end # StoriesController
