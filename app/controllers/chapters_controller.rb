class ChaptersController < ApplicationController
  ######
  # Get Section
  ######
  def show
    
  end
  
  def new
  
  end
  
  def edit
    # Step 1 : Permission
    unless user_signed_in?
      redirect_to new_user_session_path
      return
    end # unless
    @story = Story.find_by_id(params[:story_id])
    unless current_user.id == @story.owner_id
      flash[:notice] = "You cannot edit someone else's work"
      redirect_to user_path(current_user)
      return
    end # unless
    
    respond_to do |format|
      format.html do
        if params[:cmd] == "jsedit"
          @chapter = Chapter.find_by_id(params[:id])
          render "chapters/edit"
        else
          redirect_to edit_story_chapter_path(params[:story_id], params[:id]) + "?usertab=chapters"
        end # cmd = jsedit
      end # html
      format.json do
        # Step 1: Load up
        @chapter = Chapter.find_by_id(params[:id]).dirty_jsonify # 1
        @scenes = @chapter[:scenes]
        @scene_data = @chapter[:scene_data] 
        @element_relationships = @chapter[:relationships]
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
      @story = Story.find_by_id(params[:story_id])
      if @story.owner_id == current_user.id
        unless params[:chapter].nil?
          @parent = Chapter.find_by_id(params[:chapter][:parent]) unless params[:chapter][:parent].nil?
        end # unless
        if @parent.nil?
          @chapter = @story.chapters.create!(params[:chapter])
        else
          @chapter = @parent.spawn(params[:chapter])
        end # if
        flash[:success] = "New chapter creation successful"
        respond_to do |format|
          format.js 
          format.html { redirect_to edit_story_chapter_path(@story, @chapter) }
        end # respond_to
      else
        flash[:notice] = "Chapter forking not successful because forking has not been implemeneted yet. Sorry."
        respond_to do |format|
          format.js { render "errors/flash.js.erb" }
          format.html { redirect_to :back }
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
