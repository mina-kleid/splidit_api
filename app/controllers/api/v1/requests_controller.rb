class Api::V1::RequestsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @requests  = current_user.target_requests
    render :json => @requests and return
  end

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    other_user = conversation.users.delete(current_user).first
    amount = permitted_params[:amount].to_d
    post = RequestServiceObject.create(current_user,other_user,amount,conversation)
    render :json => post and return
    #TODO show errors from request
  end

  def accept
    @request = current_user.target_requests.pending.find(params[:id])
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",@request.source_id,@request.source_id).first
    success, result = RequestServiceObject.accept(@request,conversation)
    if success
      render :json => {:post => PostSerializer.new(result),:user => {:balance => current_user.balance}} and return
    end
    return api_error(result)
  end

  def reject
    @request = current_user.target_requests.pending.find(params[:id])
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",@request.source_id,@request.source_id).first
    success, result = RequestServiceObject.reject(@request,conversation)
    if success
      render :json => {:post => PostSerializer.new(result),:user => {:balance => current_user.balance}} and return
    end
    return api_error(result)
    #TODO handle errors
  end


  private


  def permitted_params
    params.require(:request).permit(:amount)
  end

end