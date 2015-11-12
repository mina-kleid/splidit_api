class Api::V1::SessionsController < ApplicationController

  before_filter :authenticate_api_key!

  def create
    @user = User.find_by_email(permitted_params[:email])
    if @user and @user.authenticate(permitted_params[:password])
      render json: @user and return
    end
    return failed_login
  end


  private


  def permitted_params
    params.require(:user).permit(:email,:password)
  end


end