require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  it "should create a new user" do
    post '/api/v1/users', {api_key:  api_key, user: {name: "test", email: "test@test.de", password: "password", phone: "01762000000"}}
    expect(response).to have_http_status(:created)
  end
end