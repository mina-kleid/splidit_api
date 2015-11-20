class Api::V1::UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :create
  before_filter :authenticate_api_key!, :only => :create

  def show
    @user = User.find(params[:id])
    if authorize_user?(@user)
      render :json => @user,serializer: UserSerializer and return
    end
    return unauthorized!
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      render :json => {:token => @user.authentication_token} and return
    end
    return api_error(@user.errors.messages)
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(permitted_params)
      render :json => @user and return
    else
      render :json => {:errors => @user.errors.messages}, :status => 400 and return
    end
  end


  def contacts

  end

  private

  def permitted_params
    params.require(:user).permit(:name,:email,:phone,:password)
  end

end