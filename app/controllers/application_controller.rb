class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:home, :about, :help]
  skip_forgery_protection
end
