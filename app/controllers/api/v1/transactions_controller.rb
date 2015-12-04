class Api::V1::TransactionsController < ApplicationController

  before_filter :authenticate_user!

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    @other_user = User.find(permitted_params[:user_id])
    return api_error(:user => "Wrong user") if (!conversation.users.include?(@other_user) or @other_user.eql?(current_user))
    amount = permitted_params[:amount].to_d
    TransactionServiceObject.create(current_user,@other_user,amount)
    @post = Post.new(:user => current_user,:target => conversation,:text => "#{current_user.name} sent #{amount} to #{@other_user.name}",:post_type => Post.post_types[:text])
    if @post.save
      render :json => {:post => PostSerializer.new(@post),:user =>{:balance => current_user.balance}} and return
    end
    return api_error(@post.errors.messages)
  end


  private


  def permitted_params
    params.require(:transaction).permit(:user_id,:amount)
  end


end