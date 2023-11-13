class ChatsController < ApplicationController
  include ChatManagement
  layout 'custom'
  before_action :set_chat, only: %i[ show edit update destroy ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.where(sender_id: current_user.id)
                 .or(Chat.where(receiver_id: current_user.id))
                 .order(last_message_at: :desc)
                 .paginate(page: params[:page], per_page: 10)
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find(params[:id])
    @message = Message.new(chat_id: @chat.id)
    @messages = @chat.messages.includes(:author).order(created_at: :asc)
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
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_message
    super(params[:id].to_i)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:sender_id, :receiver_id, :closed_by_sender, :closed_by_receiver)
    end
end
