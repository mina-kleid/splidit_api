class Api::V1::AccountsController < ApplicationController

  #simple account creation ui
  before_filter :authenticate_user!

  def show
    @account = current_user.accounts.find(params[:id])
    render :json => @account,serializer: AccountSerializer
  end

  def index
    @accounts = current_user.accounts
    render :json => @accounts,each_serializer: AccountSerializer
  end

  def create
    @account = Account.new(permitted_params)
    @account.user = current_user
    if @account.save
      render :json => @account,serializer: AccountSerializer, :status => 200 and return

    end
    return api_error(@account.errors.messages)
  end

  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update_attributes(permitted_params)
      render :json  => @account, serializer: AccountSerializer and return
    end
    return api_error(@account.errors.messages)

  end

  def withdraw
    @account = current_user.accounts.find(params[:id])
    if @account.withdraw(transaction_params[:amount])
      render :json => {:balance => current_user.balance} and return
    end
    return api_error("Transaction didnt work")
  end

  def deposit
    @account = current_user.accounts.find(params[:id])
    if @account.deposit(transaction_params[:amount])
      render :json => {:balance => current_user.balance} and return
    end
    return api_error("Transaction didnt work")
  end


  private


  def permitted_params
    params.require(:account).permit(:iban,:bic,:account_name)
  end

  def transaction_params
    params.require(:transaction).permit(:amount)
  end

end