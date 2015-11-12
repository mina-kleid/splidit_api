class UsersController < ApplicationController


  #TODO this is a simple user api, not ready for use yet
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    render :json => @user
  end

  def create
    @user = User.new(permitted_params)

    if @user.save
      render :json => @user
    else
      render :json => {:errors => @user.errors.full_messages}, :status => 400
    end

  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(permitted_params)
      render :json => @user
    else
      render :json => {:errors => @user.errors.full_messages}, :status => 400
    end
  end


  def contacts

  end

  private

  def permitted_params
    params.require(:user).permit(:name,:email,:phone)
  end

end