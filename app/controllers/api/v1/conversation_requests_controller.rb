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
      post, transaction = ConversationServiceObject.accept_request(request, conversation)
      render json: {:post =>PostSerializer.new(post),:request => RequestSerializer.new(request), transaction: TransactionSerializer.new(transaction) },:root => false, status: status_success and return
    rescue StandardError => e
      return api_error(e.message)
    end
  end

  def reject
    request = current_user.received_requests.find(params[:id])
    unless request.pending?
      return api_error("Request not in pending status")
    end
    conversation = current_user.conversations.where("user1_id = ? or user2_id = ?",request.source.owner_id,request.source.owner_id).first
    begin
      post = ConversationServiceObject.reject_request(request, conversation)
      render json: {:post =>PostSerializer.new(post),:request => RequestSerializer.new(request)},:root => false, status: status_success and return
    rescue StandardError => e
      return api_error(e.message)
    end
  end


  private


  def permitted_params
    params.require(:request).permit(:amount,:text)
  end

end