class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:about, :help, :welcome]
  skip_forgery_protection
end
