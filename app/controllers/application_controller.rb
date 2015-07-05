require 'oauth/request_proxy/rack_request'
class ApplicationController < ActionController::API

    #commented to stop oauth from working
    # before_filter :run_oauth_check


  protected

  def run_oauth_check
    #TODO some work done on oauth, but need further work
    req = OAuth::RequestProxy::RackRequest.new(request)
    return render :json => { :error => "Invalid request" },
                  :status => 400 unless req.parameters['oauth_consumer_key']

    client = User.find_by_api_key req.parameters['oauth_consumer_key']
    return render :json => { :error => "Invalid credentials" },
                  :status => 401 unless client != nil

    begin
      signature = ::OAuth::Signature.build(::Rack::Request.new(env)) do |rp|
        [nil, client.signature]
      end

      return render :json => { :error => "Invalid credentials" },
                    :status => 401 unless signature.verify
    rescue ::OAuth::Signature::UnknownSignatureMethod => e
      return render :json => { :error => "Unknown signature method" }, :status => 400
    end
  end


end
