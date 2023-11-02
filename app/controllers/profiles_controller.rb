class ProfilesController < ApplicationController
  layout 'custom'
  def show
    user_id = params.fetch(:id)
    @user = User.where(:id => user_id)[0]
    render 'profiles/show'
  end

  def search
    country = "%#{params[:country]}%"
    state = "%#{params[:state]}%"
    city = "%#{params[:city]}%"

    @profiles = User.where("country LIKE ? OR state LIKE ? OR city LIKE ?", country, state, city).paginate(page: params[:page], per_page: 10)
    render 'profiles/index'
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
