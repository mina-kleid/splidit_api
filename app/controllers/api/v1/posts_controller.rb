class Api::V1::PostsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    puts @user.id
    puts current_user.id
    return unauthorized! unless @user.eql?(current_user)
    @conversation = @user.conversations.find(params[:conversation_id])
    @post = Post.new(permitted_params)
    @post.user = @user
    @post.target = @conversation
    @post.post_type = Post.post_types[:text]
    if @post.save
      render :json => @post and return
    end
    return api_error(@post.errors.full_messages)
  end


  private


  def permitted_params
    params.require(:post).permit(:text)
  end

end