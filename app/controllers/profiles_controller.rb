class ProfilesController < ApplicationController
  include ChatManagement

  before_action :set_profile, only: [:show]
  before_action :redirect_if_current_profile, only: [:show]
  layout 'custom'

  def show
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @is_blocked_by_current_user = current_user.blocked_users.exists?(blocked_id: @user.id)
    @is_current_user_blocked = @user.blocked_users.exists?(blocked_id: current_user.id)
    record_visit unless current_user == @user
    render 'profiles/show'
  end

  def index
    @q = User.ransack(params[:q])

    @age_gt = params.dig(:q, :age_gt) || 18
    @age_lt = params.dig(:q, :age_lt) || 60

    if current_user.gender == "male"
      @profiles = @q.result(distinct: true)
                    .where(gender: "female")
                    .order(created_at: :desc) # Ordering by created_at in descending order
                    .paginate(page: params[:page], per_page: 10)
    else
      @profiles = @q.result(distinct: true)
                    .where(gender: "male")
                    .order(created_at: :desc) # Ordering by created_at in descending order
                    .paginate(page: params[:page], per_page: 10)
    end

    render 'profiles/index'
  end

  def send_message_to_profile
    super(params[:id].to_i)
  end

  def block
    @user = User.find(params[:id])
    current_user.blocked_users.find_or_create_by(blocked_id: @user.id)
    @is_blocked_by_current_user = true

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to profile_path(params[:id]) }
    end
  end

  def unblock
    @user = User.find(params[:id])
    current_user.blocked_users.find_by(blocked_id: @user.id).destroy
    @is_blocked_by_current_user = false

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to profile_path(params[:id]) }
    end
  end

  def like
    @user = User.find(params[:id])
    Favorite.create(liking_user: current_user, liked_user: @user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user, notice: 'User has been added to favorites.' }
    end
  end

  def unlike
    @user = User.find(params[:id])
    favorite = Favorite.find_by(liking_user: current_user, liked_user: @user)
    favorite&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user, notice: 'User has been removed from favorites.' }
    end
  end

  private

  def record_visit
    visit = Visit.find_or_initialize_by(visitor: current_user, visited: @user)
    if visit.persisted?
      visit.touch
    else
      visit.save
    end
  end
  def post_params
    params.require(:q).permit(:state_cont, :city_cont, :country_cont, :age_min_cont, :age_max_cont)
  end

  def set_profile
    @user = User.find(params[:id])
  end

  # Redirect the current_user to the dashboard if they are trying to view their own profile
  def redirect_if_current_profile
    if current_user == @user
      redirect_to dashboard_path
    end
  end
end
