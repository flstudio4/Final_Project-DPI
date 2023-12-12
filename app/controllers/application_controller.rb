class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, except: [:welcome]
  before_action :update_last_seen_at, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :gender, :avatar, :country, :state, :city, :dob, :bio, :name) }

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :avatar, :country, :state, :city, :bio, :password, :password_confirmation, :current_password, :name) }
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || dashboard_path)
  end

  def update_last_seen_at
    current_user.update(last_seen_at: Time.current) if user_signed_in?
  end
end
