class Api::V1::ConversationsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @conversation = current_user.conversations.find(params[:id])
    render :json => @conversation,show_all_posts: true
  end

  def index
    @conversations = current_user.conversations
    render :json => @conversations,show_all_posts: false
  end

  def create
    @second_user = User.find(permitted_params[:user_id])
    conversation_ids = current_user.conversations.where("user1_id = ? or user2_id = ?",@second_user.id,@second_user.id).pluck(:id)
    if conversation_ids.any?
      @conversation = Conversation.find(conversation_ids.first)
      render :json => @conversations,show_all_posts: false and return
    end
    @conversation = Conversation.new(:first_user => current_user,:second_user => @second_user)
    if @conversation.save
      render :json => @conversation and return
    end
    return api_error(@conversation.errors.messages)
  end


  private

  def permitted_params
    params.require(:conversation).permit(:user_id)
  end

end