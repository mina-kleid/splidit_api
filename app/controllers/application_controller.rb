# require 'oauth/request_proxy/rack_request'
class ApplicationController < ActionController::API

    #commented to stop oauth from working
    # before_filter :run_oauth_check


  protected

  def check_api_key!
    api_key = Rails.application.secrets.api_key
    return params[:api_key].eql?(api_key) ? true : wrong_api_key!
  end

  def authenticate_user!
    check_api_key!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    user_email = options.blank?? nil : options[:email]
    user = user_email && User.find_by(email: user_email)
    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    render :json => {:errors => "Unauthorized"}, :status => 401
  end

  def wrong_api_key!
    render :json => {:errors => "Wrong api key"}, :status => 401
  end

  def api_error(error)
    render :json => error, :status => 400
  end

  # def run_oauth_check
  #   #TODO some work done on oauth, but need further work
  #   req = OAuth::RequestProxy::RackRequest.new(request)
  #   return render :json => { :error => "Invalid request" },
  #                 :status => 400 unless req.parameters['oauth_consumer_key']
  #
  #   client = User.find_by_api_key req.parameters['oauth_consumer_key']
  #   return render :json => { :error => "Invalid credentials" },
  #                 :status => 401 unless client != nil
  #
  #   begin
  #     signature = ::OAuth::Signature.build(::Rack::Request.new(env)) do |rp|
  #       [nil, client.signature]
  #     end
  #
  #     return render :json => { :error => "Invalid credentials" },
  #                   :status => 401 unless signature.verify
  #   rescue ::OAuth::Signature::UnknownSignatureMethod => e
  #     return render :json => { :error => "Unknown signature method" }, :status => 400
  #   end
  # end


end
