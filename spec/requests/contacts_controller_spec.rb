require 'rails_helper'

describe Api::V1::ContactsController, type: :request do

  describe "sync contacts" do

    let!(:user) {create(:user)}
    let!(:users) {create_list(:user, 20)}
    let!(:phone_numbers) {users[0 .. 10].map {|user| user.phone}}

    it "should return the list of contacts" do
      post "/api/v1/contacts/sync",{api_key:  api_key, contacts: {phone_numbers: phone_numbers}}, header_for_user(user)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      contacts = parsed_body["contacts"]
      expect(contacts.count).to eq(phone_numbers.count)
    end

    it "should return an empty list if no contacts was given" do
      post "/api/v1/contacts/sync",{api_key:  api_key, contacts: {phone_numbers: [nil]}}, header_for_user(user)
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      contacts = parsed_body["contacts"]
      expect(contacts).to be_empty
    end

  end

end