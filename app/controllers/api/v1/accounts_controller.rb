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
      render :json => @account,serializer: AccountSerializer, status: status_created and return

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
    result = AccountTransactionServiceObject.withdraw_from_account(@account,current_user,transaction_params[:amount].to_d.abs)
    if result
      render :json => {:balance => current_user.balance} and return
    end
    return api_error("Transaction didnt work")
  end

  def deposit
    @account = current_user.accounts.find(params[:id])
    result = AccountTransactionServiceObject.deposit_to_account(@account,current_user,transaction_params[:amount].to_d.abs)
    if result
      render :json => {:balance => current_user.balance} and return
    end
    return api_error("Insufficient funds")
  end


  private


  def permitted_params
    params.require(:account).permit(:iban,:bic,:account_name,:account_number,:blz)
  end

  def transaction_params
    params.require(:transaction).permit(:amount)
  end

end