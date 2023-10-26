class StaticPagesController < ApplicationController
  def home
    render 'static_pages/home'
  end

  def about
    render 'static_pages/about'
  end

  def help
    render 'static_pages/help'
  end
end
