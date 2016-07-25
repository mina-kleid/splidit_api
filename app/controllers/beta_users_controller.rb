class BetaUsersController < ActionController::Base

  after_filter :allow_iframe

  def new
    @beta_user = BetaUser.new
    render :new
  end

  def create
    @beta_user = BetaUser.new(permitted_params)
    puts @beta_user.inspect
    if @beta_user.save
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