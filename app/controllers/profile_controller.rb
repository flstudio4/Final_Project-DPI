class ProfileController < ApplicationController
  layout 'custom'
  def show
    render 'profile/show'
  end

  def index
    @profiles = User.all
    render 'profile/index'
  end
end
