class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :create
  before_filter :check_api_key!, :only => :create

  def show
    @user = User.find(params[:id])
    render :json => @user
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      render :json => @user, status: 200 and return
    end
    return api_error(@user.errors.full_messages)
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(permitted_params)
      render :json => @user and return
    else
      render :json => {:errors => @user.errors.full_messages}, :status => 400 and return
    end
  end


  def contacts

  end

  private

  def permitted_params
    params.require(:user).permit(:name,:email,:phone,:password)
  end

end