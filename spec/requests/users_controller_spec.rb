require 'rails_helper'

describe Api::V1::UsersController, type: :request do

  describe "create user" do
    it "should create a new user with the right data" do
      post '/api/v1/users', {api_key:  api_key, user: {name: "test", email: "test@test.de", password: "password", phone: "01762000000"}}
      expect(response).to have_http_status(:created)
    end
  end

  describe "update user" do
    before(:each) do
      @user = create(:user)
    end
    it "should update the user pin" do
      put "/api/v1/users/#{@user.id}",{api_key: api_key, user: {pin: '1234'}}, header_for_user(@user)
      user = assigns[:user]
      expect(response).to have_http_status(:success)
      expect(user.encrypted_pin).not_to be_nil
    end
  end

end