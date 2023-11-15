class DashboardController < ApplicationController
  layout 'custom'

  def home
    @blocked_users = Block.where(:blocker_id => current_user.id)
    @messages_count = Message.all.where(:author_id => current_user.id).count
    @chats_count = Chat.where(sender_id: current_user.id).or(Chat.where(receiver_id: current_user.id)).count

    if current_user.gender == "male"
      @profiles = User.where(:gender => "female").paginate(page: params[:page], per_page: 10)
    else
      @profiles = User.where(:gender => "male").paginate(page: params[:page], per_page: 10)
    end
    render 'dashboard/dashboard'
  end
end
