class Api::V1::ContactsController < ApplicationController

  before_filter :authenticate_user!

  def sync
    phone_numbers = permitted_params[:phone_numbers]
    unless phone_numbers.present?
      render :json => [], :each_serializer => ContactSerializer and return
    end
    users = ContactsServiceObject.matched_users(phone_numbers).where.not(:phone => current_user.phone)
    render :json => users, :each_serializer => ContactSerializer and return
  end


  private


  def permitted_params
    params.require(:contacts).permit(phone_numbers:[])
  end
end