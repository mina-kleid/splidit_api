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

  describe "index transactions" do
    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:user_3) {create(:user)}
    let!(:conversation) {create(:conversation, first_user: user_1, second_user: user_2)}
    let!(:transactions) {create_list(:transaction, 5, :credit, source: user_1.account, target: user_2.account)}
    let!(:other_transactions) {create_list(:transaction, 5, :credit, source: user_3.account, target: user_2.account)}

    it "should return all transactions in the conversation" do
      get "/api/v1/conversations/#{conversation.id}/transactions", {api_key:  api_key}, header_for_user(user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("conversation")
      expect(parsed_body).to have_key("transactions")
      transactionsJSON = parsed_body["transactions"]
      expect(transactionsJSON.size).to eq(transactions.size)
    end

  end
end