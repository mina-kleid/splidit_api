class Api::V1::TransactionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    other_user = conversation.users.where("id != ?",current_user.id).first
    amount = permitted_params[:amount].to_d
    success, result = TransactionServiceObject.create(current_user, other_user, amount, conversation)
    if success
      render :json => {:post => PostSerializer.new(result), :user => {:balance => current_user.balance}} and return
    end
    return api_error(result)
    #TODO handle errors
  end


  private


  def permitted_params
    params.require(:transaction).permit(:amount)
  end


end