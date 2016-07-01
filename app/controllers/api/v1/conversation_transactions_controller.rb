class Api::V1::ConversationTransactionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    other_user = conversation.other_user(current_user)
    amount = permitted_params[:amount].to_d.abs
    text = permitted_params[:text]
    begin
      post, transaction = ConversationServiceObject.create_transaction(current_user, other_user, conversation, amount, text)
      render :json => {:post => PostSerializer.new(post), :user => {:balance => current_user.balance}, transaction: TransactionSerializer.new(transaction)},:root => false, status: status_created and return
    rescue StandardError => e
      return api_error(e.message)
    end
  end


  private


  def permitted_params
    params.require(:transaction).permit(:amount,:text)
  end


end