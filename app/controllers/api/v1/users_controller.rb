class Api::V1::UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :create
  before_filter :authenticate_api_key!, :only => :create

  def show
    render :json => current_user,serializer: UserSerializer and return
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      render :json => {:token => @user.authentication_token}, status: status_created and return
    end
    return api_error(@user.errors.messages)
  end

  def update
    @user = current_user
    if @user.update_attributes(permitted_update_params)
      render :json => @user, status: status_success and return
    else
      render :json => {:errors => @user.errors.messages}, :status => 400 and return
    end
  end

  def device_token
    if current_user.update_attribute(:device_token,device_token_params[:device_token])
      render :json => {:user => {:device_token => current_user.device_token} },:root => false and return
    end
    return api_error(:user =>{:device_token => "Device token couldnt be updated"})
  end


  private

  def permitted_update_params
    params.require(:user).permit(:pin,:name,:email,:phone,:password,:is_phone_verified)
  end

  def permitted_params
    params.require(:user).permit(:name,:email,:phone,:password)
  end

  def device_token_params
    params.require(:user).permit(:device_token)
  end

end