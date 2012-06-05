class ElementsController < ApplicationController
  
  #######
  # POST
  #######
  def create
    # Step 1: Redirection
    unless user_signed_in?
      redirect_to new_user_session_path
      return
    end # unless
    
    # Step 2: Creation
    if params[:element].nil? || params[:element][:picture].nil?
      flash[:notice] = "You have come with some bad data"
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to :back }
        return
      end # respond_to
    end # if
    @element = Element.new(params[:element])
    unless @element.save
      flash[:notice] = "You have come with some bad data"
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to :back }
        return
      end # respond_to
    end # unless
    
    # Step 2.5: Linking
    @story = Story.find_by_id(params[:story_id]) unless params[:story_id].nil?
    if !@story.nil? && current_user.id == @story.owner_id
      @chapter = Chapter.find_by_id(params[:chapter_id]) unless params[:chapter_id].nil?
      result ||= @chapter.fork(@element) unless @chapter.nil?
      result ||= @story.fork(@element) if @chapter.nil?
    else # if
      result ||= current_user.fork(@element)
    end # if
    
    # Step 3: Confirmation
    unless result.nil?
      flash[:success] = "Successfully uploaded picture"
      respond_to do |format|
        format.js
        format.html { redirect_to :back }
      end # respond_to
    else
      flash[:notice] = "Something went wrong with the uploading"
      respond_to do |format|
        format.js { render "errors/flash.js.erb" }
        format.html { redirect_to :back }
      end # respond_to
    end # if
  end # create

  #######
  # DELETE
  #######
  def destroy
  end # destroy

  #######
  # UPDATE
  #######
  def update
  end # update

end # ElementsController
