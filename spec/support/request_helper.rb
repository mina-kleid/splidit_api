module RequestHelper

  def api_key
    return Rails.application.secrets.api_key
  end

  RSpec.configure do |config|
    config.include RequestHelper, :type => :request
  end
end