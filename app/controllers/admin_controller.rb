class AdminController < ApplicationController
  before_action :check_email
  layout 'custom'

  def index
    @users = User.all.order(:created_at => :desc).paginate(page: params[:page], per_page: 10)
    render 'admin/admin_panel'
  end

  def user_info
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    render "admin/user_info"
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      respond_to do |format|
        format.turbo_stream do
          flash[:notice] = "User was successfully deleted."
          redirect_to admin_panel_path
        end
      end
    end
  end

  def messages
    user_id = params[:user_id]
    chat_id = params[:chat_id]
    @user = User.find(user_id)
    @chat = Chat.find(chat_id)
    @chats = Chat.where(sender_id: user_id).or(Chat.where(receiver_id: user_id))
    @messages = Message.where(chat_id: chat_id)
    render "admin/chats_show"
  end

  def chats
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @chats = Chat.where(sender_id: user_id).or(Chat.where(receiver_id: user_id)).paginate(page: params[:page], per_page: 10)
    @messages = Message.where(:author_id => user_id)
    render "admin/chats_index"
  end

  def blocks
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @blocker_to = Block.where(:blocker_id => user_id).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render "admin/blocks"
  end

  def blocked
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @blocked_by = Block.where(:blocked_id => user_id).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render "admin/blocked"
  end

  def likes
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @likes = Favorite.where(:liking_user_id => user_id).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render "admin/likes"
  end

  def liked
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @liked_by = Favorite.where(:liked_user_id => user_id).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render "admin/liked"
  end

  def visitors
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @visitors = Visit.all.where(:visited_id => @user.id).order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
    render 'admin/visitors'
  end

  def visited
    user_id = params.fetch(:id)
    @user = User.find(user_id)
    @visited = Visit.all.where(:visitor_id => @user.id).order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
    render 'admin/visited'
  end

  private

  def check_email
    unless current_user && current_user.email == 'flstudio444@gmail.com'
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
