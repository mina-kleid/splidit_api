# require 'oauth/request_proxy/rack_request'
class ApplicationController < ActionController::API

  include ActionController::Serialization
    #commented to stop oauth from working
    # before_filter :run_oauth_check


  protected

  def current_user
    @current_user
  end

  def authorize_user?(user)
    if current_user and current_user.eql?(user)
      return true
    end
    return false
  end

  def authenticate_api_key!
    api_key = Rails.application.secrets.api_key
    return params[:api_key].eql?(api_key) ? true : wrong_api_key!
  end

  def authenticate_user!
    authenticate_api_key!
    token, options = ::ActionController::HttpAuthentication::Token.token_and_options(request)
    user_email = options.blank?? nil : options[:email]
    user = user_email && User.find_by(email: user_email)
    if user && ::ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    render :json => {:errors => "Unauthorized"}, :status => 401
  end

  def unauthorized!
    render :json => {:errors => "Unauthorized"}, :status => 401
  end

  def failed_login
    render json: {errors: ["Wrong email/password"]},:status => 401
  end

  def wrong_api_key!
    render :json => {:errors => "Wrong api key"}, :status => 401
  end

  def api_error(errors)
    unless errors.is_a?(Array)
      errors = [errors]
    end
    render json: {errors: errors}, status: 400
  end

  def status_created
    201
  end

  def status_success
    200
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
