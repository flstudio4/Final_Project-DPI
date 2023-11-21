class FavoritesController < ApplicationController
  include ChatManagement
  layout 'custom'
  before_action :set_favorite, only: [:destroy]
  before_action :set_user, only: [:create]

  # GET /favorites or /favorites.json
  def index
    @favorites = Favorite.all.where(:liking_user_id => current_user.id).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  # GET /favorites/1 or /favorites/1.json
  def show
  end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit
  end

  # POST /favorites or /favorites.json
  def create
    @favorite = current_user.favorites.build(liked_user: @user)

    if @favorite.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path(@user), notice: 'User was successfully added to favorites.' }
      end
    else
      redirect_to profile_path(@user), alert: 'Unable to add user to favorites.'
    end
  end

  # DELETE /favorites/1 or /favorites/1.json
  def destroy
    @user = @favorite.liked_user
    if @favorite.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path(@user), notice: 'User was successfully removed from favorites.' }
      end
    else
      redirect_to profile_path(@user), alert: 'Unable to remove user from favorites.'
    end
  end

  def send_message_to_profile
    super(params[:id].to_i)
  end

  private

  def set_user
    @user = User.find(params[:id] || params[:liked_user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite
    @favorite = Favorite.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def favorite_params
    params.require(:favorite).permit(:liking_user_id, :liked_user_id)
  end
end
