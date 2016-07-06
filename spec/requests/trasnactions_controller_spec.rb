require 'rails_helper'

describe Api::V1::TransactionsController, type: :request do

  describe "show all transactions" do

    let!(:user_1) {create(:user)}
    let!(:user_2) {create(:user)}
    let!(:transactions_list)  {create_list(:transaction, 5, :credit, source: user_1.account, target: user_2.account)}

    it "sould list all the transactions from the user" do
      get "/api/v1/transactions/",{api_key:  api_key}, header_for_user(user_1)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to have_key("transactions")
      transactions = parsed_body["transactions"]
      expect(transactions.size).to eq(transactions_list.count)
      expect(transactions[0]["date"]).to be >=(transactions[1]["date"])
    end

  end

end
