module RequestHelper

  def api_key
    return Rails.application.secrets.api_key
  end

  def header_for_user(user)
    {Authorization: "Token token=#{user.authentication_token}, email=#{user.email}"}
  end

  RSpec.configure do |config|
    config.include RequestHelper, :type => :request
  end
end