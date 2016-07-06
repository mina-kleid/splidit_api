class Api::V1::TransactionsController < ApplicationController

  before_filter :authenticate_user!

  def index
    transactions = current_user.transactions.order("created_at DESC")
    render json: transactions, each_serailizer: TransactionSerializer, status: status_success and return
  end

end