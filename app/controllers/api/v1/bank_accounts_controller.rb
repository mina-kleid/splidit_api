class Api::V1::BankAccountsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @account = current_user.bank_accounts.find(params[:id])
    render :json => @account, serializer: BankAccountSerializer
  end

  def index
    @accounts = current_user.bank_accounts
    render :json => @accounts, each_serializer: BankAccountSerializer, root: :accounts
  end

  def create
    @account = BankAccount.new(permitted_params)
    @account.user = current_user
    if @account.save
      render :json => @account, serializer: BankAccountSerializer, status: status_created and return

    end
    return api_error(@account.errors.full_messages)
  end

  def update
    @account = current_user.bank_accounts.find(params[:id])
    if @account.update_attributes(permitted_params)
      render :json  => @account, serializer: BankAccountSerializer and return
    end
    return api_error(@account.errors.full_messages.full_messages)

  end

  def withdraw
    @account = current_user.bank_accounts.find(params[:id])
    result = BankAccountTransactionServiceObject.withdraw_from_account(@account, current_user, transaction_params[:amount].to_d.abs)
    if result
      render :json => {:balance => current_user.balance} and return
    end
    return api_error(transaction: ["Transaction didnt work"])
  end

  def deposit
    @account = current_user.bank_accounts.find(params[:id])
    result = BankAccountTransactionServiceObject.deposit_to_account(@account, current_user, transaction_params[:amount].to_d.abs)
    if result
      render :json => {:balance => current_user.balance} and return
    end
    return api_error(transaction: ["Insufficient funds"])
  end


  private


  def permitted_params
    params.require(:account).permit(:iban, :name, :bic, :account_holder, :account_number, :blz)
  end

  def transaction_params
    params.require(:transaction).permit(:amount)
  end

end