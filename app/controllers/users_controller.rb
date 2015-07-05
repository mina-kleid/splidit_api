class UsersController < ApplicationController



  def show
    @user = User.find(params[:id]) rescue nil
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

  private

  def permitted_params
    params.require(:user).permit(:name,:email,:phone)
  end

end