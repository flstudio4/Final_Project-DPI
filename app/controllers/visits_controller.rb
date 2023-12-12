class VisitsController < ApplicationController
  layout 'custom'
  before_action :set_visit, only: [:destroy]

  def index
    @visitors = Visit.all.where(:visited_id => current_user.id).order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
    render "visits/index"
  end

  def destroy
    if @visit.visited_id == current_user.id
      @visit.destroy

      respond_to do |format|
        format.html { redirect_to chats_path }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to visitors_path, alert: 'You are not authorized to delete this visit.' }
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
  end
end
