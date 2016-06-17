require 'rails_helper'

describe Api::V1::ConversationRequestsController, type: :request do

  describe "create a request" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}

    it "should return a money request" do
      post "/api/v1/conversations/#{conversation.id}/requests", {api_key:  api_key, request: {amount: 10, text: "test"}}, header_for_user(user_1)
      expect(response).to have_http_status(:created)
      parsed_body = JSON.parse(response.body)
      puts parsed_body.inspect
    end

  end
end