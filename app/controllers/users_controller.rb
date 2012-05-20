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
  end # end index
  
  def create
    @user = User.new( params[:user] )
    if @user.save
      respond_to do |format|
        format.html do 
          flash[:success] = "User created!"
          render @user
         end # end format.html
         format.js
      end # end respond_to
    else
      respond_to do |format|
        format.html do 
          flash[:error] = "Failed for some reason"
          redirect_to :back
        end # end format.html
      end # end respond_to
    end # end if-else
  end # end create
  
  def destroy
  
  end # end destroy
  
  def update
  
  end # end update
end # end UsersController
