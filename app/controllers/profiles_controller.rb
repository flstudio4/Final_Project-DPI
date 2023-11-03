class ProfilesController < ApplicationController
  layout 'custom'
  def show
    user_id = params.fetch(:id)
    @user = User.where(:id => user_id)[0]
    render 'profiles/show'
  end

  def index
    @q = User.ransack(params[:q])

    if current_user.gender == "male"
      @profiles = @q.result(distinct: true).where(:gender => "female").paginate(page: params[:page], per_page: 10)
    else
      @profiles = @q.result(distinct: true).where(:gender => "male").paginate(page: params[:page], per_page: 10)
    end
    render 'profiles/index'
  end

  private

  def post_params
    params.require(:q).permit(:state_cont, :city_cont, :country_cont, :age_min_cont, :age_max_cont)
  end
end
