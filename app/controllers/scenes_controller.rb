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
      flash.now[:notice] = "You must be signed in"
      render "errors/flash.js.erb"
      return
    end # unless
    @chapter = Chapter.find_by_id(params[:chapter_id])
    
    # Step 1.5: Forking
    # TODO: properly handle external forking
    unless params[:parent_id].nil?
      @parent = Scene.find_by_id(params[:parent_id]) 
      unless @parent.nil?
        @scene = @parent.spawn 
        flash[:success] = "Forking successful"
        render "scenes/show.json.json_builder"
        return  
      end # unless @parent.nil
    end # unless parent_id.nil
    
    # Step 1.75: wrong user redirects
    unless @chapter.owner_id == current_user.id
      flash.now[:notice] = "This belongs to #{@chapter.owner_id} and you are #{current_user.id}"
      render "errors/flash.js.erb"
      return
    end # unless
    
    # Step 2: Create
    respond_to do |format|
      @scene = @chapter.scenes.create( params[:scene] )
      if @scene
          @scene.owner_id = @chapter.owner_id
          flash.now[:success] = "Scene creation successful"
          format.js if @scene.save
          format.html { puts "success" }
          return
      end # end
      flash.now[:notice] = "Something went wrong"
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
    
    # Step 1.5: Check batch
    if params[:batch] == true
    	scenes = params[:scenes]
    	layers = []
    	scenes.each do |scene|
    	  scene[:layers].each do |layer|
    	    layers << layer
    	  end # layers.each
    	end # scenes.each
    	Scene.batch_import( scenes )
    	Layer.batch_import( layers )
    	respond_to do |format|
    		format.js
    	end # respond_to
    	return
    end # if
    
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
