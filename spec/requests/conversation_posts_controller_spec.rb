require 'rails_helper'

describe Api::V1::ConversationPostsController, type: :request do

  describe "should create a new post in the conversation" do

    before(:all) do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @conversation = create(:conversation, :with_posts, first_user: @user_1, second_user: @user_2)
    end

    it "should create a new post in the conversation" do
      old_posts_count = @conversation.posts.count
      post_text = "special text for post"
      post "/api/v1/conversations/#{@conversation.id}/posts",{api_key:  api_key, post: {text: post_text}}, header_for_user(@user_1)
      expect(response).to have_http_status(201)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["post"]).not_to be_empty
      expect(@conversation.posts.count).to eq(old_posts_count + 1)
      expect(@conversation.posts.last.text).to eq(post_text)
    end
  end
  describe "retrieves the conversation and its posts" do

    before(:all) do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @conversation = create(:conversation, :with_posts, first_user: @user_1, second_user: @user_2)
      @page = 1
      @last_post_id = @conversation.posts.last.id
      @last_page = (@conversation.posts.count.to_f / ConversationPost.per_page.to_f).ceil
      @first_page_size = @conversation.posts.paginate(page: @last_page).to_a.size
    end
    it "should fetch the first page of conversations ordered chronologically" do
      get "/api/v1/conversations/#{@conversation.id}/posts",{api_key:  api_key, post: {page: @page}}, header_for_user(@user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["posts"]).not_to be_empty
      expect(parsed_body["posts"].size).to be(@first_page_size)
      posts = parsed_body["posts"]
      expect(posts[@first_page_size - 1]["id"]).to eq(@last_post_id)
      expect(posts[0]["created_at"]).to be < (posts[1]["created_at"])

    end
    it "should fetch the second page of conversations ordered chronologically" do
      get "/api/v1/conversations/#{@conversation.id}/posts",{api_key:  api_key, post: {page: @page + 1}}, header_for_user(@user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      posts = parsed_body["posts"]
      size = @conversation.posts.paginate(page: @last_page - 1).to_a.size
      expect(parsed_body["posts"].size).to be(size)
      expect(posts[size - 1]["id"]).to eq(@last_post_id - @first_page_size )
    end

    it "should fetch all posts when there is no page params" do
      get "/api/v1/conversations/#{@conversation.id}/posts",{api_key:  api_key, post: {page: ''}}, header_for_user(@user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      size = @conversation.posts.count
      expect(parsed_body["posts"].size).to be(size)
    end
  end
end