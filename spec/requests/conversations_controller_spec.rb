require 'rails_helper'

describe Api::V1::ConversationsController, type: :request do




  describe "Create new conversations" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}

    it "should create a new conversation between two users" do
      post "/api/v1/conversations", {api_key:  api_key, conversation: {user_id: user_2.id}}, header_for_user(user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["conversation"]).not_to be_empty
      expect(parsed_body["conversation"]).to have_key("user1_id")
      expect(parsed_body["conversation"]).to have_key("user2_id")
      expect(parsed_body["conversation"]["user1_id"]).to eq(user_1.id)
      expect(parsed_body["conversation"]["user2_id"]).to eq(user_2.id)
      expect(parsed_body["conversation"]).to have_key("posts")
    end
  end

  describe "fetches already existing conversation between users instead of creating a new one" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}

    it "should return the already existing conversation between users " do
      post "/api/v1/conversations", {api_key:  api_key, conversation: {user_id: user_2.id}}, header_for_user(user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["conversation"]).not_to be_empty
      expect(parsed_body["conversation"]).to have_key("user1_id")
      expect(parsed_body["conversation"]).to have_key("user2_id")
      expect(parsed_body["conversation"]["user1_id"]).to eq(user_1.id)
      expect(parsed_body["conversation"]["user2_id"]).to eq(user_2.id)
      expect(parsed_body["conversation"]["id"]).to eq(conversation.id)
      expect(parsed_body["conversation"]).to have_key("posts")
    end
  end
  describe "retrieves the conversation and its posts" do

    before(:all) do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @conversation = create(:conversation, :with_posts, first_user: @user_1, second_user: @user_2)
      @page = 1
      @first_post_id = @conversation.posts.first.id
    end
    it "should fetch the first page of conversations ordered chronologically" do
      get "/api/v1/conversations/#{@conversation.id}",{api_key:  api_key, conversation: {user_id: @user_1.id, page: @page}}, header_for_user(@user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["conversation"]).not_to be_empty
      expect(parsed_body["conversation"]["posts"]).not_to be_empty
      expect(parsed_body["conversation"]["posts"].count).to be(15)
      posts = parsed_body["conversation"]["posts"]
      expect(posts[0]["id"]).to eq(@first_post_id)
      expect(posts[0]["created_at"]).to be > (posts[1]["created_at"])

    end
    it "should fetch the first page of conversations ordered chronologically" do
      get "/api/v1/conversations/#{@conversation.id}",{api_key:  api_key, conversation: {user_id: @user_1.id, page: @page + 1}}, header_for_user(@user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      posts = parsed_body["conversation"]["posts"]
      expect(posts[0]["id"]).to eq(@first_post_id - 15)
    end
  end
end