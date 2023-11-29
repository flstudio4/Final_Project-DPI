class ChatsController < ApplicationController
  include ChatManagement
  layout 'custom'
  before_action :set_chat, only: %i[ show edit update destroy ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.where(sender_id: current_user.id)
                 .or(Chat.where(receiver_id: current_user.id))
                 .order(Arel.sql("last_message_at DESC NULLS LAST"))
                 .paginate(page: params[:page], per_page: 10)
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find(params[:id])
    @message = Message.new(chat_id: @chat.id)
    @messages = @chat.messages.includes(:author).order(created_at: :asc)
    authorize @chat

    other_user_id = @chat.sender_id == current_user.id ? @chat.receiver_id : @chat.sender_id

    # Check if current_user is blocked by the other participant in the chat
    if Block.exists?(blocker_id: other_user_id, blocked_id: current_user.id)
      redirect_to request.referer, alert: "You cannot access this chat, because you were blocked by the user."
    end
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_path }
      format.turbo_stream
    end
  end

  def send_message
    super(params[:id].to_i)
  end

  private

  def blocked?(chat, user)
    other_user = chat.participant_other_than(user)
    Block.exists?(blocker_id: other_user.id, blocked_id: user.id)
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:sender_id, :receiver_id, :closed_by_sender, :closed_by_receiver)
    end
end
