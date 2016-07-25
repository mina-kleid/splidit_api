require 'mailchimp'

class BetaUsersController < ActionController::Base

  after_filter :allow_iframe
  layout 'application'

  def new
    @beta_user = BetaUser.new
    render :new
  end

  def create
    @beta_user = BetaUser.new(permitted_params)
    if @beta_user.save
      mailchimp = Mailchimp::API.new(MAILCHIMP_API_KEY)
      mailchimp.lists.subscribe(MAILCHIMP_LIST_ID, {email: @beta_user.email}, {first_name: @beta_user.first_name, last_name: @beta_user.last_name}, double_optin = false, send_welcome = false)
      redirect_to success_beta_users_path
    else
      render :new
    end
  end

  def success

  end


  private


  def permitted_params
    params.require(:beta_user).permit(:first_name, :last_name, :email)
  end


  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

end