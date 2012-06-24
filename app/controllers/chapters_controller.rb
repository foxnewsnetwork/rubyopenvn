class ChaptersController < ApplicationController
  ######
  # Get Section
  ######
  def show
    @story = Story.find_by_slug( params[:story_id] )
    @story ||= Story.find_by_id( params[:story_id] )
    @chapter = Chapter.find_by_id( params[:id] )
    if @story.nil? || @chapter.nil?
      render "pages/404.html.erb"
    end # if
  end # show
  
  def new
  
  end
  
  def edit
    # Step 1 : Permission
    unless user_signed_in?
      redirect_to new_user_session_path
      return
    end # unless
      @story = Story.find_by_slug(params[:story_id])
      @story ||= Story.find_by_id(params[:story_id])
    unless current_user.id == @story.owner_id
      flash[:notice] = "You cannot edit someone else's work"
      redirect_to user_path(current_user)
      return
    end # unless
    
    respond_to do |format|
      format.html do
        if params[:cmd] == "jsedit"
          @chapter = Chapter.find_by_id(params[:id])
          render "chapters/edit", :layout => false
        else
          redirect_to edit_story_chapter_path(@story, params[:id]) + "?usertab=chapters"
        end # cmd = jsedit
      end # html
      format.json do
        # Step 1: Load up
        @chapter = Chapter.find_by_id(params[:id]).iky_jsonify # (3 hits to the database)
        @scenes = @chapter[:scenes]
        @layers = @chapter[:layers] 
        @elements = @chapter[:elements]
        @stockpile = current_user.elements
        
        # Step 2: Render
        render "chapters/edit.json.json_builder"
      end # json
    end # respond_to
  end # edit
  
  def index
  
  end

  ######
  # Post Section
  ######
  def create
    if user_signed_in?
      @story = Story.find_by_slug(params[:story_id])
      @story ||= Story.find_by_id(params[:story_id])
      if @story.owner_id == current_user.id
        unless params[:chapter].nil?
          @parent = Chapter.find_by_id(params[:chapter][:parent]) unless params[:chapter][:parent].nil?
        end # unless
        if @parent.nil?
          @chapter = @story.chapters.create(params[:chapter])
        else
          @chapter = @parent.spawn(params[:chapter])
        end # if
        flash[:success] = "New chapter creation successful"
        respond_to do |format|
          format.js 
          format.html { redirect_to edit_story_chapter_path(@story, @chapter) + "?usertab=chapters" }
        end # respond_to
      else
        flash[:notice] = "Chapter forking not successful because forking has not been implemeneted yet. Sorry."
        respond_to do |format|
          format.js { render "errors/flash.js.erb" }
          format.html { redirect_to user_path( current_user ) }
        end # respond_to
      end # if
    else
      flash[:notice] = "You cannot make new chapters without signing in, buddy."
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to new_user_session_path }
      end # respond_to
    end # if
  end # create
  
  ######
  # Put Section
  ######
  def update
    if user_signed_in?
        @chapter = Chapter.find_by_id( params[:id] )
        @story = @chapter.story
        # Batch updates
        if params[:batch] == "true" || params[:batch] == true || !params[:scenes].nil?
        	# Because I don't want to pull out N scenes for each one a user might
        	# have altered before doing batch updating, I will trust in my scrpt to
        	# do client-side validations. This, of course, introduces a security
        	# vulnerability since a smart client can spoof up his owner_id and directly
        	# alter someone else's scene and layer.
        	# 
        	# If I ever get to the point where someone thinks highly enough of my
        	# little project to hack it, I hope by then I will have already resolved
        	# this issue.
        	# 
        	# TL;DR : exploit here, not gonna fix until someone exploits it
        	if params[:scenes].is_a?(Array)
        		scenes = params[:scenes].map { |scene| scene if scene[:owner_id] == current_user.id }.compact
        	elsif params[:scenes].is_a(Hash)
	        	scenes = params[:scenes].map { |key, scene| scene if scene[:owner_id] == current_user.id }.compact
	        end # if dumbshit
        	# Not using the above line because of an issue with visualnovel.js not correctly serializing owner_id
#        	scenes = params[:scenes].map { |key, scene| scene }
					layers = []
					scenes.each do |scene|
						unless scene[:layers].nil? || scene[:layers].empty?
							scene[:layers].each do |layer|
								layers << layer
							end # layers.each
						end # unless no layers
					end # scenes.each
			 		
					Scene.batch_import( scenes )
					Layer.batch_import( layers )
					respond_to do |format|
						format.js
					end # respond_to
					return
				end # if batch updates
        if current_user.id == @story.owner_id
          @chapter.update_attributes( params[:chapter] )
          flash[:notice] = "Successfully updated chapter attributes"
          respond_to do |format|
            format.js
            format.html { redirect_to edit_story_chapter_path(@story, @chapter) }
          end # respond_to
        else
          flash[:error] = "Failed due to permissions conflict"
          respond_to do |format|
            format.js
            format.html { redirect_to edit_story_chapter_path(@story, @chapter) }
          end # respond_to
        end # if
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
    if user_signed_in?
      @story = Story.find_by_id(params[:story_id])
      if @story.owner_id == current_user.id
        @chapter = Chapter.find_by_id(params[:id])
        @chapter.delete
        flash[:notice] = "Story successfully deleted."
      else
        flash[:notice] = "Story deletion failed because you're not the owner of this story."
      end # if
      respond_to do |format|
        format.js
        format.html { redirect_to :back }
      end # respond_to
    else 
      flash[:notice] = "Delete failed because you are not allowed to delete stuff without signing in."
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to new_user_session_path }
      end # respond_to
    end # if
  end # destroy
end # ChaptersController
