require 'rails_helper'

describe Api::V1::PostsController, type: :request do

  describe "should create a new post in the conversation" do

    before(:all) do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @conversation = create(:conversation, :with_posts, first_user: @user_1, second_user: @user_2)
    end

    it "should create a new post in the conversation" do
      old_posts_count = @conversation.posts.count
      post_text = "special text for post"
      post "/api/v1/conversations/#{@conversation.id}/posts",{api_key:  api_key, post: {text: post_text}}, header_for_user(@user_1)
      expect(response).to have_http_status(201)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).not_to be_empty
      expect(parsed_body).not_to have_key("errors")
      expect(parsed_body["post"]).not_to be_empty
      expect(@conversation.posts.count).to eq(old_posts_count + 1)
      expect(@conversation.posts.first.text).to eq(post_text)
    end
  end
end