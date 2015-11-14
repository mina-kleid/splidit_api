class Api::V1::ConversationsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @conversation = @user.conversations.find(params[:id])
    render :json => @conversation
  end

  def index
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @conversations = @user.conversations
    render :json => @conversations
  end

  def create
    @user = User.find(params[:user_id])
    return unauthorized! unless current_user.eql?(@user)
    @second_user = User.find(permitted_params[:user_id])
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