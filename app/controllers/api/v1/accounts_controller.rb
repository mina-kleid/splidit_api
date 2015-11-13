class Api::V1::AccountsController < ApplicationController

  #simple account creation ui
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:user_id])
    return unauthorized! unless authorize_user?(@user)
    @account = @user.accounts.find(params[:id])
    render :json => @account,serializer: AccountSerializer
  end

  def index
    @user = User.find(params[:user_id])
    return unauthorized! unless authorize_user?(@user)
    @accounts = @user.accounts
    render :json => @accounts,each_serializer: AccountSerializer
  end

  def create
    @user = User.find(params[:user_id])
    return unauthorized! unless authorize_user?(@user)
    @account = Account.new(permitted_params)
    @account.user = @user
    if @account.save
      render :json => @account,serializer: AccountSerializer, :status => 200 and return

    end
    return api_error(@account.errors.full_messages)
  end

  def update
    @user = User.find(params[:user_id])
    @account = @user.accounts.find(params[:id])
    if @account.update_attributes(permitted_params)
      render :json  => "success"
    else
      render :json => {:errors => @account.errors.full_messages}, :status => 400
    end
  end

  private

  def permitted_params
    params.require(:account).permit(:iban,:bic,:account_name)
  end

end