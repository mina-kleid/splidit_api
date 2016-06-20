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
    let!(:amount) {"10.0"}
    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}
    let!(:request) {create(:request, :pending, source: user_1.account, target: user_2.account, amount: amount)}


    it "should accept a pending request" do
      post "/api/v1/conversations/#{conversation.id}/requests/#{request.id}/accept", {api_key:  api_key}, header_for_user(user_2)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("post")
      expect(parsed_body).to have_key("request")
      expect(parsed_body).to have_key("transaction")
      transaction = parsed_body["transaction"]
      request_json = parsed_body["request"]
      post = parsed_body["post"]
      expect(transaction["amount"]).to eq(amount)
      expect(transaction["transaction_type"]).to eq("debit")
      expect(transaction["source"]).to eq(request_json["target"])
      expect(transaction["target"]).to eq(request_json["source"])
      expect(post["user_id"]).to eq(request_json["target"])
      expect(post["user_id"]).to eq(transaction["source"])
      expect(request_json["status"]).to eq("accepted")
      expect(post["post_type"]).to eq("request_accepted")
      expect(post["amount"]).to eq(amount)
    end

    it "should not accept a pending request with insufficient funds" do
      user_2_balance = user_2.account.balance
      request.amount = user_2_balance + 0.01
      request.save
      post_count = ConversationPost.count
      transaction_count = Transaction.count
      post "/api/v1/conversations/#{conversation.id}/requests/#{request.id}/accept", {api_key:  api_key}, header_for_user(user_2)
      expect(response).to have_http_status(400)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body).not_to have_key("post")
      expect(parsed_body).not_to have_key("request")
      expect(parsed_body).not_to have_key("transaction")
      expect(ConversationPost.count).to eq(post_count)
      expect(Transaction.count).to eq(transaction_count)
      expect(user_2.account.balance).to eq(user_2_balance)
    end

    it "should not accept a non pending request" do
      request.status = Request.statuses[:accepted]
      request.save
      post_count = ConversationPost.count
      transaction_count = Transaction.count
      post "/api/v1/conversations/#{conversation.id}/requests/#{request.id}/accept", {api_key:  api_key}, header_for_user(user_2)
      expect(response).to have_http_status(400)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body).not_to have_key("post")
      expect(parsed_body).not_to have_key("request")
      expect(parsed_body).not_to have_key("transaction")
      expect(ConversationPost.count).to eq(post_count)
      expect(Transaction.count).to eq(transaction_count)
    end
  end
  describe "reject request" do

  end
end