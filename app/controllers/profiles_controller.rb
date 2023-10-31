class ProfilesController < ApplicationController
  layout 'custom'
  def show
    user_id = params.fetch(:id)
    @user = User.where(:id => user_id)[0]
    render 'profiles/show'
  end

  def index
    if current_user.gender == "male"
      @profiles = User.where(:gender => "female").paginate(page: params[:page], per_page: 10)
    else
      @profiles = User.where(:gender => "male").paginate(page: params[:page], per_page: 10)
    end
    render 'profiles/index'
  end
end
