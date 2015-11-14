class Api::V1::GroupsController < ApplicationController


  def index

  end

  def create
    @group = Group.new(permitted_params.except(:user_ids,:admin_ids,:creator_id))
    @users = User.find(permitted_params[:user_ids])
    @group.creator = User.find(permitted_params[:creator_id])
    @group.users << @users
    @group.set_admins(permitted_params[:admin_ids])

    if @group.save
      render :json => @group,serializer: GroupSerializer
    else
      render :json => {:errors => @group.errors.messages},:status => 400
    end
  end

  def update

  end

  def destroy

  end

  def permitted_params
    params.require(:group).permit(:name,:sum_per_person,:type,:description,:creator_id,:user_ids => [],:admin_ids => [])
  end

end