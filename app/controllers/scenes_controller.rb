class ScenesController < ApplicationController
  ######
  # Get Section
  ######
  def index
    @chapter = Chapter.find_by_id(params[:chapter_id])
    @scenes = @chapter.scenes
    respond_to do |format|
      format.js { render "scenes/index.js.erb" }
      format.html { render "scenes/index.html.erb" }
    end # respond_to
  end # index

  ######
  # Post Section
  ######
  def create
    # Step 1: Check permission
    unless user_signed_in?
      render "errors/flash.js.erb"
      return
    end # unless
    @chapter = Chapter.find_by_id(params[:chapter_id])
    unless @chapter.owner_id == current_user.id
      render "errors/flash.js.erb"
      return
    end # unless
    
    # Step 2: Create
    respond_to do |format|
      @scene = @chapter.scenes.create( params[:scene] )
      if @scene
          @scene.owner_id = @chapter.owner_id
          format.js if @scene.save
          return
      end # end
      format.js { "errors/flash.js.erb" }
    end # respond_to
  end # create
  
  ######
  # Put Section
  ######
  def update
    # Step 1: Check permission
    unless user_signed_in?
      render "errors/flash.js.erb"
      return
    end # unless
    @scene = Scene.find_by_id(params[:id])
    unless @scene.owner_id == current_user.id
      render "errors/flash.js.erb"
      return
    end # unless
    
    # Step 2: Update
    respond_to do |format|
      if @scene.update_attributes( params[:scene] )
        format.js
      else 
        format.js { render "errors/flash.js.erb" }
      end # if
    end # respond_to
  end # update
  
  ######
  # Delete Section
  ######
  def destroy
    # Step 1: Check permission
    unless user_signed_in?
      render "errors/flash.js.erb"
      return
    end # unless
    @scene = Scene.find_by_id(params[:id])
    unless @scene.owner_id == current_user.id
      render "errors/flash.js.erb" 
      return
    end # unless
    
    # Step 2: Delete
    respond_to do |format|
      if @scene.delete
        # Step 3: Render response
        format.js { 
          render "scenes/destroy.js.erb"
        }
      else
        format.js { 
          render "errors/flash.js.erb"
        }
      end # @scene.destroy
    end # respond_to
  end # destroy
end # ScenesController
