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
      render :json => @conversation and return
    end
    @conversation = Conversation.new(:first_user => current_user,:second_user => @second_user)
    if @conversation.save
      render :json => @conversation and return
    end
    return api_error(@conversation.errors.messages)
  end

  def transaction
    @other_user = User.find(permitted_params[:user_id])
    amount = params[:amount]
    TransactionServiceObject.create(current_user,@other_user,amount)
    @post = Post.new(:user => current_user,:target => @other_user,:text => "#{current_user.name} sent #{amount} to #{@other_user.name}")
    if @post.save
      render :json =>:post.merge(current_user) and return
    end
    return api_error(@post.errors.messages)

  end


  private

  def permitted_params
    params.require(:conversation).permit(:user_id,:amount)
  end

end