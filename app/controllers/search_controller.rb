class SearchController < ApplicationController
  layout 'custom'

  def index
    render 'search/index'
  end
end
