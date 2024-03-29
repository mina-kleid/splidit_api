require 'rails_helper'

describe Api::V1::BankAccountsController, type: :request do


  let!(:user) {create(:user)}


  describe "create bank account with iban" do

    it "should create a bank account for the user" do
      iban = 'DE89370400440532013000'
      post "/api/v1/accounts", {api_key:  api_key, account: {iban: iban, account_holder: user.name}}, header_for_user(user)
      expect(response).to have_http_status(:created)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("account")
      expect(user.bank_accounts.first.iban).to eq(iban)
    end

    it "should not create a bank account with a faulty iban" do
      iban = 'faultyiban'
      post "/api/v1/accounts", {api_key:  api_key, account: {iban: iban, account_holder: user.name}}, header_for_user(user)
      parsed_body = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(user.bank_accounts).to be_empty
    end

  end

  describe "create bank account with account number and blz" do

    it "should create account with account number and blz and generate iban" do
      iban = 'DE89370400440532013000'
      account_number = "532013000"
      blz = "37040044"
      post "/api/v1/accounts", {api_key:  api_key, account: {account_number: account_number, blz: blz}}, header_for_user(user)
      expect(response).to have_http_status(:created)
      expect(user.bank_accounts).not_to be_empty
      expect(user.bank_accounts.first.iban).to eq(iban)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("account")
    end

    it "should not create a bank account with faulty account number" do
      account_number = "532013000122"
      blz = "37040044"
      post "/api/v1/accounts", {api_key:  api_key, account: {account_number: account_number, blz: blz}}, header_for_user(user)
      expect(response).to have_http_status(400)
      expect(user.bank_accounts).to be_empty
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(user.bank_accounts).to be_empty
    end
  end

  describe "create bank account with missing data" do

    it "should not create bank account with missing bank code" do
      account_number = "532013000"
      post "/api/v1/accounts", {api_key:  api_key, account: {account_number: account_number}}, header_for_user(user)
      expect(response).to have_http_status(400)
      expect(user.bank_accounts).to be_empty
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
    end
  end

  describe "list all bank accounts" do

    let!(:bank_account_1) {create(:bank_account, user: user)}
    let!(:bank_account_2) {create(:bank_account, user: user)}

    it "should list all bank accounts" do
      get "/api/v1/accounts", {api_key:  api_key}, header_for_user(user)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("accounts")
      expect(parsed_body["accounts"].count).to eq(2)
    end
  end

  describe "show bank account" do

    let!(:bank_account) {create(:bank_account, user: user)}

    it "should show the bank account" do
      get "/api/v1/accounts/#{bank_account.id}", {api_key:  api_key}, header_for_user(user)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("account")
    end
  end

  describe "Withdraw from account to user" do

    let!(:bank_account) {create(:bank_account, user: user)}

    it "withdraw to the user balance" do
      transactions_count = Transaction.count
      user_old_balance = user.account.balance
      amount = 10
      post "/api/v1/accounts/#{bank_account.id}/withdraw", {api_key:  api_key, transaction: {amount: amount}}, header_for_user(user)
      user.reload
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("balance")
      expect(parsed_body["balance"].to_d).to eq(user_old_balance + amount)
      expect(user.balance).to eq(user_old_balance + amount)
      expect(Transaction.count).to eq(transactions_count + 2)
      expect(Transaction.credit.first.balance_after).to eq(user_old_balance + amount)
    end

    it "deposit to the user account" do
      transactions_count = Transaction.count
      user_old_balance = user.account.balance
      amount = 10
      post "/api/v1/accounts/#{bank_account.id}/deposit", {api_key:  api_key, transaction: {amount: amount}}, header_for_user(user)
      user.reload
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body).to have_key("balance")
      expect(parsed_body["balance"].to_d).to eq(user_old_balance - amount)
      expect(user.account.balance).to eq(user_old_balance - amount)
      expect(Transaction.count).to eq(transactions_count + 2)
      expect(Transaction.debit.first.balance_after).to eq(user_old_balance - amount)
    end

    it "should not take money from the user if he doesnt have enough funds" do
      transactions_count = Transaction.count
      user_old_balance = user.account.balance
      amount = 100.1
      post "/api/v1/accounts/#{bank_account.id}/deposit", {api_key:  api_key, transaction: {amount: amount}}, header_for_user(user)
      user.reload
      expect(response).to have_http_status(400)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).to have_key("errors")
      expect(parsed_body).not_to have_key("balance")
      expect(user.account.balance).to eq(user_old_balance)
      expect(Transaction.count).to eq(transactions_count)
    end
  end
end
