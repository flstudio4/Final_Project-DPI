class DashboardController < ApplicationController
  layout 'custom'

  def home
    if current_user.gender == "male"
      @profiles = User.where(:gender => "female").paginate(page: params[:page], per_page: 10)
    else
      @profiles = User.where(:gender => "male").paginate(page: params[:page], per_page: 10)
    end
    render 'dashboard/dashboard'
  end
end
