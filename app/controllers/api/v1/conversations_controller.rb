class Api::V1::ConversationsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @conversation = current_user.conversations.find(params[:id])
    #TODO remove this when implemented in phone
    if permitted_params[:page].present?
      render :json => @conversation, show_paged_posts: true, page: permitted_params[:page] and return
    end
    render :json => @conversation, show_all_posts: true and return
  end

  def index
    @conversations = current_user.conversations
    render :json => @conversations, show_all_posts: false
  end

  def create
    @second_user = User.find(permitted_params[:user_id])
    conversation_ids = current_user.conversations.where("user1_id = ? or user2_id = ?",@second_user.id,@second_user.id).pluck(:id)
    if conversation_ids.any?
      @conversation = Conversation.find(conversation_ids.first)
      render :json => @conversation, show_all_posts: false and return
    end
    @conversation = Conversation.new(:first_user => current_user,:second_user => @second_user)
    if @conversation.save
      render :json => @conversation and return
    end
    return api_error(@conversation.errors.full_messages)
  end


  private

  def permitted_params
    params.require(:conversation).permit(:user_id,:page)
  end

end