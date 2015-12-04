class Api::V1::RequestsController < ApplicationController

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    @other_user = conversation.users.find(params[:user_id])
    return api_error(:user => "Wrong user") if @other_user.eql?(current_user)
    amount = permitted_params[:amount].to_d
    post = RequestServiceObject.create(current_user,@other_user,amount,conversation)
    render :json => post and return
    #TODO show errors from request
  end

  def accept
    @request = current_user.target_requests.pending.find(params[:id])
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",@request.source_id,@request.source_id)
    post = RequestServiceObject.accept(@request,conversation)
    render :json => {:post => PostSerializer.new(post),:user => {:balance => current_user.balance}} and return
    #TODO handle errors
  end

  def reject
    @request = current_user.target_requests.pending.find(params[:id])
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",@request.source_id,@request.source_id)
    post = RequestServiceObject.reject(@request,conversation)
    render :json => {:post => PostSerializer.new(post),:user => {:balance => current_user.balance}} and return
    #TODO handle errors
  end


  private


  def permitted_params
    params.require(:request).permit(:user_id,:amount)
  end

end