require 'rails_helper'

describe Api::V1::ConversationRequestsController, type: :request do

  describe "create a request" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}

    it "should return a money request" do
      amount = "10.0"
      post "/api/v1/conversations/#{conversation.id}/requests", {api_key:  api_key, request: {amount: amount, text: "test"}}, header_for_user(user_1)
      expect(response).to have_http_status(:created)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("post")
      expect(parsed_body).to have_key("request")
      request = parsed_body["request"]
      post = parsed_body["post"]
      expect(request["amount"]).to eq(amount)
      expect(request["request_status"]).to eq(Request.statuses[:request_pending])
      expect(post["amount"]).to eq(amount)
      expect(ConversationPost.post_types[post["post_type"]]).to eq(ConversationPost.post_types[:request])
    end

  end

  describe "accept a request" do
    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}
    let!(:request) {create(:request, :pending, source: user_1.account, target: user_2.account, amount: 10)}

    it "should accept a pending request" do
      post "/api/v1/conversations/#{conversation.id}/requests/#{request.id}/accept", {api_key:  api_key}, header_for_user(user_2)
      parsed_body = JSON.parse(response.body)
      puts parsed_body.inspect
    end
  end
end