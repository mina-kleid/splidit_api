class Api::V1::TransactionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    other_user = conversation.other_user(current_user)
    amount = permitted_params[:amount].to_d.abs
    success, result = TransactionServiceObject.create(current_user, other_user, amount, conversation)
    if success
      APNS.send_notification(other_user(current_user).device_token, :alert => 'You have received money', :badge => 1, :sound => 'default',
                             :other => {:conversation_id => conversation.id}) unless other_user.device_token.nil?
      render :json => {:post => PostSerializer.new(result), :user => {:balance => current_user.balance}},:root => false and return
    end
    return api_error(result)
    #TODO handle errors
  end


  private


  def permitted_params
    params.require(:transaction).permit(:amount)
  end


end