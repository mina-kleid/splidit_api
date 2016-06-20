class Api::V1::ConversationRequestsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @requests  = current_user.target_requests
    render :json => @requests and return
  end

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    other_user = conversation.other_user(current_user)
    amount = permitted_params[:amount].to_d.abs
    text = permitted_params[:text]
    begin
      post, request = ConversationServiceObject.create_request(current_user, other_user, conversation, amount, text)
      render json: {:post =>PostSerializer.new(post),:request => RequestSerializer.new(request)},:root => false, status: status_created and return
    rescue Errors::RequestNotCompletedError => e
      return api_error(e.message)
    end
  end

  def accept
    request = current_user.received_requests.find(params[:id])
    unless request.pending?
      return api_error("Request not in pending status")
    end
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",request.source.owner_id,request.source.owner_id).first
    begin

    rescue
    end
    success = RequestServiceObject.accept(@request)
    if success
      other_user = conversation.other_user(current_user)
      APNS.send_notification(other_user.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                             :other => {:conversation_id => conversation.id}) unless other_user.device_token.nil?
      post = ConversationPost.create(:user => current_user, :target => conversation, amount: amount, :post_type => ConversationPost.post_types[:request_accepted])
      render :json => {:post => PostSerializer.new(post),:user => {:balance => current_user.balance}},:root => false and return
    end
    return api_error("Insufficient funds")
  end

  def reject
    @request = current_user.target_requests.pending.find(params[:id])
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",@request.source_id,@request.source_id).first
    success, result = RequestServiceObject.reject(@request)
    if success
      other_user = conversation.other_user(current_user)
      APNS.send_notification(other_user.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                             :other => {:conversation_id => conversation.id}) unless other_user.device_token.nil?
      post = ConversationPost.create(:user => current_user, :target => conversation, amount: amount, :post_type => ConversationPost.post_types[:request_rejected])
      render :json => {:post => PostSerializer.new(post),:user => {:balance => current_user.balance}},:root => false and return
    end
    return api_error("error")
    #TODO handle errors
  end


  private


  def permitted_params
    params.require(:request).permit(:amount,:text)
  end

end