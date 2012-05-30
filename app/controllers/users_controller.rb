class UsersController < ApplicationController
  def show
    @user = User.find_by_id( params[:user] )
    @usertab = params[:usertab]
    if @user.nil?
      render "pages/404"
    end
  end # end show

  def edit
  end # end edit

  def new
    @user = User.new
  end # end new

  def index
    @user = User.all
  end # end index
  
  def create
    # Step 1: Check permission
    if user_signed_in?
      flash[:notice] = "You've failed, please log out if you want to make another account."
      redirect_to :back
      return
    end # if
    
    # Step 2: Creation
    @user = User.new( params[:user] )
    if @user.save
      flash[:notice] = "Your account has been successfully crerated."
      redirect_to users_path(@user)
    else
      flash[:notice] = "Something went wrong, account creation failed."
      redirect_to :back
    end # if
  end # end create
  
  def destroy
    # Step 1: Permission
    unless user_signed_in? && current_user.id == params[:id]
      redirect_to :back
      flash[:notice] = "You have failed to delete someone else's account."
      return
    end # unless
    
    # Step 2: Deleting
    @user = User.find_by_id(params[:id])
    if @user.delete
      flash[:notice] = "Account deletion successful."
      redirect_to root_path
    else
      flash[:notice] = "Something went wrong with the database. Oh no."
      redirect_to root_path
    end # if
  end # end destroy
  
  def update
    # Step 1: permission
    unless user_signed_in?
      flash[:notice] = "You have failed because you need to sign in first."
      redirect_to new_user_session_path
      return
    end # unless
    unless current_user.id == params[:id]
      flash[:notice] = "You have failed to delete someone else's account."
      redirect_to :back
      return
    end # unless
    
    # Step 2: updating
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account update successful"
      redirect_to users_path @user
    else
      flash[:notice] = "Something went wrong with the update"
      redirect_to :back
    end # if
  end # end update
end # end UsersController
