class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:welcome]
  skip_forgery_protection
end
