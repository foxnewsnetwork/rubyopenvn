class ElementsController < ApplicationController
  
  #######
  # POST
  #######
  def create
    # Step 1: Redirection
    unless user_signed_in?
      flash[:notice] = "You must be logged in to submit artwork."
      redirect_to new_user_session_path
      return
    end # unless
    
    # Step 2: Creation
    if params[:element].nil? || params[:element][:picture].nil?
      flash[:notice] = "You have failed to even come with data."
      redirect_to :back
      return
    end # if
    @element = Element.new(params[:element])
    unless @element.save
      flash[:notice] = "You have failed to come with good file data."
      redirect_to :back
      return
    end # unless
    
    # Step 2.5: Linking
    @story = Story.find_by_id(params[:story_id]) unless params[:story_id].nil?
    if @story.nil?
      result ||= current_user.fork(@element)
      flash[:success] = "Successfully uploaded" unless result.nil?
      flash[:notice] = "Something went wrong with uploading." if result.nil?
    else
      if current_user.id == @story.owner_id
        @chapter = Chapter.find_by_id(params[:chapter_id]) unless params[:chapter_id].nil?
        unless @chapter.nil?
          result ||= @chapter.fork(@element) 
          flash[:success] = "Successfully uploaded to #{@chapter.title}" unless result.nil?
          flash[:notice] = "Something went wrong with the upload." if result.nil?
        else
          result ||= @story.fork(@element) 
          flash[:success] = "Successfully uploaded to #{@story.title}" unless result.nil?
          flash[:notice] = "Something went wrong with the upload." if result.nil?
        end # @chapter.nil?
      else
        result ||= current_user.fork(@element)
        flash[:notice] = "You aren't the owner of this story."
        flash[:success] = "But we forked it under your user account anyway."
      end # current_user.id == @story.owner_id
    end # @story.nil?
    
    # Step 3: Confirmation
    redirect_to :back
    
  end # create

  #######
  # DELETE
  #######
  def destroy
    unless user_signed_in?
      flash[:notice] = "You need to be an admin to delete this junk."
      respond_to do |format|
        format.js
        format.html { redirect_to new_user_session_path }
      end # respond_to  
    end # if    
  end # destroy

  #######
  # UPDATE
  #######
  def update
  end # update

end # ElementsController
