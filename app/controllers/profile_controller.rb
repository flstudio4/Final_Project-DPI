class ProfileController < ApplicationController
  layout 'custom'
  def show
    render 'profile/show'
  end

  def index
    @profiles = User.paginate(page: params[:page], per_page: 10)
    render 'profile/index'
  end
end
