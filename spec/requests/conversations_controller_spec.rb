require 'rails_helper'

describe Api::V1::ConversationsController, type: :request do


  let!(:user_1) {create(:user)}
  let!(:user_2) {create(:user)}

  describe "Create new conversations" do
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

    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}

    it "should return the already existing conversation between users" do
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
end