class HomeController < ApplicationController
  layout 'custom'
  def home
    render 'home/home'
  end
end
