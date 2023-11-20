class MessagesController < ApplicationController
  layout 'custom'
  before_action :set_message, only: %i[ show destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)
    @message.author = current_user
    @message.author_id = current_user.id
    authorize @message

    respond_to do |format|
      if  @message.save
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.append('messages', partial: 'messages/message', locals: { message: @message })
            ]
          end
          format.html { redirect_to chats_path(@message.chat_id), notice: "Message sent!" }
      else
        format.turbo_stream do
          render chats_path turbo_stream: turbo_stream.replace('message_form', partial: 'messages/form', locals: { message: @message })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:chat_id, :author_id, :content)
    end
end
