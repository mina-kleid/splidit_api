require 'rails_helper'

describe Api::V1::AccountsController, type: :request do


  let!(:user) {create(:user)}


  describe "create bank account" do
    it "should create a bank account for the user" do
      iban = 'DE89370400440532013000'
      post "/api/v1/accounts", {api_key:  api_key, account: {iban: iban, account_name: user.name}}, header_for_user(user)
      expect(response).to have_http_status(:created)
      expect(user.accounts.first.iban).to eq(iban)
    end
  end
end
