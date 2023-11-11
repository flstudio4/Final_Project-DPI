class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show]
  before_action :redirect_if_current_profile, only: [:show]
  layout 'custom'
  def show
    user_id = params.fetch(:id)
    @user = User.where(:id => user_id)[0]
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

  private
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
