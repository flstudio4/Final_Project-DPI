class StaticPagesController < ApplicationController
  def welcome
    render 'static_pages/landing'
  end
end
