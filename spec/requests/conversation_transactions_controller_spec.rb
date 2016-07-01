require 'rails_helper'

describe Api::V1::ConversationRequestsController, type: :request do

  describe "create transaction" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}

    it "should create a successful transaction between user" do
      amount = "10.0"
      post "/api/v1/conversations/#{conversation.id}/transactions", {api_key:  api_key, transaction: {amount: amount, text: "test"}}, header_for_user(user_1)
      expect(response).to have_http_status(:created)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("post")
      expect(parsed_body).to have_key("transaction")
      transaction = parsed_body["transaction"]
      post = parsed_body["post"]
      expect(transaction["amount"]).to eq(amount)
      expect(post["amount"]).to eq(amount)
      expect(transaction["transaction_type"]).to eq("debit")
      expect(post["user_id"]).to eq(transaction["source"])
      expect(post["post_type"]).to eq("transactions")
    end

    it "should return an error when there is insufficient funds" do
      amount = (user_1.account.balance + 0.01).to_s
      post "/api/v1/conversations/#{conversation.id}/transactions", {api_key:  api_key, transaction: {amount: amount, text: "test"}}, header_for_user(user_1)
      expect(response).to have_http_status(:bad_request)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body).not_to have_key("post")
      expect(parsed_body).not_to have_key("transaction")
    end
  end
end