class Api::V1::PostsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @post = Post.new(permitted_params)
    @post.user = current_user
    @post.target = @conversation
    @post.post_type = Post.post_types[:text]
    if @post.save
      APNS.send_notification(@conversation.other_user(current_user), :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                             :other => {:conversation_id => @conversation.id})
      render :json => @post and return
    end
    return api_error(@post.errors.messages)
  end


  private


  def permitted_params
    params.require(:post).permit(:text)
  end

end