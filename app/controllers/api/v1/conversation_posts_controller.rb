class Api::V1::ConversationPostsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @conversation = current_user.conversations.find(params[:conversation_id])
    #TODO remove this when implemented on phone
    if permitted_params[:page].present?
      page = permitted_params[:page].to_i
      reversed_page = @conversation.reverse_pagination(page)
      @posts = @conversation.posts.paginate(page: reversed_page)
    else
      @posts = @conversation.posts.all
    end
    render :json =>  {conversation: @conversation, posts: @posts} and return
  end

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    other_user = @conversation.other_user(current_user)
    @post = ConversationPost.new(permitted_params)
    @post.user = current_user
    @post.conversation = @conversation
    @post.post_type = ConversationPost.post_types[:text]
    if @post.save
      APNS.send_notification(other_user.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                             :other => {:conversation_id => @conversation.id}) unless other_user.device_token.nil?
      render :json => PostSerializer.new(@post), status: status_created and return
    end
    return api_error(@post.errors.full_messages)
  end


  private


  def permitted_params
    params.require(:post).permit(:text,:page)
  end

end