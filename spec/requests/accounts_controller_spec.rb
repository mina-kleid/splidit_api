require 'rails_helper'

describe Api::V1::AccountsController, type: :request do


  let!(:user) {create(:user)}


  describe "create bank account with iban" do

    it "should create a bank account for the user" do
      iban = 'DE89370400440532013000'
      post "/api/v1/accounts", {api_key:  api_key, account: {iban: iban, account_name: user.name}}, header_for_user(user)
      expect(response).to have_http_status(:created)
      expect(user.accounts.first.iban).to eq(iban)
    end

    it "should not create a bank account with a faulty iban" do
      iban = 'faultyiban'
      post "/api/v1/accounts", {api_key:  api_key, account: {iban: iban, account_name: user.name}}, header_for_user(user)
      parsed_body = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body["errors"]).to have_key("iban")
      expect(parsed_body["errors"]).not_to have_key("account_number")
      expect(user.accounts).to be_empty
    end

  end

  describe "create bank account with account number and blz" do

    it "should create account with account number and blz and generate iban" do
      iban = 'DE89370400440532013000'
      account_number = "532013000"
      blz = "37040044"
      post "/api/v1/accounts", {api_key:  api_key, account: {account_number: account_number, blz: blz, account_name: user.name}}, header_for_user(user)
      expect(response).to have_http_status(:created)
      expect(user.accounts).not_to be_empty
      expect(user.accounts.first.iban).to eq(iban)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
    end

    it "should not create a bank account with faulty account number" do
      account_number = "532013000122"
      blz = "37040044"
      post "/api/v1/accounts", {api_key:  api_key, account: {account_number: account_number, blz: blz, account_name: user.name}}, header_for_user(user)
      expect(response).to have_http_status(400)
      expect(user.accounts).to be_empty
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body["errors"]).to have_key("account_number")
      expect(parsed_body["errors"]).to have_key("blz")
      expect(parsed_body["errors"]).not_to have_key("iban")
      expect(user.accounts).to be_empty
    end
  end
end
