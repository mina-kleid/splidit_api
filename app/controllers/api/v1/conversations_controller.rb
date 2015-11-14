class Api::V1::ConversationsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @conversation = @user.conversations.find(params[:id])
    render :json => @conversation,show_all_posts: true
  end

  def index
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @conversations = @user.conversations
    render :json => @conversations,show_all_posts: false
  end

  def create
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @second_user = User.find(permitted_params[:user_id])
    conversation_ids = @user.conversations.where("user1_id = ? or user2_id = ?",@second_user.id,@second_user.id).pluck(:id)
    if conversation_ids.any?
      @conversation = Conversation.find(conversation_ids.first)
      render :json => @conversation and return
    end
    @conversation = Conversation.new(:first_user => @user,:second_user => @second_user)
    if @conversation.save
      render :json => @conversation and return
    end
    return api_error(@conversation.errors.full_messages)
  end


  private

  def permitted_params
    params.require(:conversation).permit(:user_id)
  end

end