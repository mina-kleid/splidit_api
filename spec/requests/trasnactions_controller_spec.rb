require 'rails_helper'

describe Api::V1::TransactionsController, type: :request do

  describe "show all transactions" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:credit_transactions)  {create_list(:transaction, 5, :credit,target: user_1.account, source: user_2.account)}
    let!(:debit_transactions)   {create_list(:transaction, 5, :debit, target: user_2.account, source: user_1.account)}

    it "sould list all the transactions from the user" do
      get "/api/v1/transactions/",{api_key:  api_key}, header_for_user(user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to have_key("transactions")
      transactions = parsed_body["transactions"]
      expect(transactions.size).to eq(credit_transactions.size + debit_transactions.size)
      expect(transactions[0]["created_at"]).to be <=(transactions[1]["created_at"])
    end

  end

end
