class Api::V1AccountsController < ApplicationController

  #simple account creation ui

  def show
    @account = Account.find(params[:id]) rescue nil
    render :json => @account
  end

  def index
    @user = User.find(params[:user_id])
    @accounts = @user.accounts
  end

  def create
    @user = User.find(params[:user_id])
    @account = Account.new(permitted_params)
    @account.user = user
    if @account.save
      render :json => "success"
    else
      render :json => {:errors => @account.errors.full_messages}, :status => 400
    end
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