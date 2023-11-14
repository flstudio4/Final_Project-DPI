class BlocksController < ApplicationController
  layout 'custom'
  before_action :set_block, only: %i[ show edit update destroy ]

  # GET /blocks or /blocks.json
  def index
    @blocks = Block.all
  end

  # GET /blocks/1 or /blocks/1.json
  def show
  end

  # GET /blocks/new
  def new
    @block = Block.new
  end

  # GET /blocks/1/edit
  def edit
  end

  # POST /blocks or /blocks.json
  def create
    @block = current_user.blocked_users.new(blocked_id: params[:blocked_id])
    if @block.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profiles_path(@block.blocked), notice: 'User blocked.' }
      end
    else
      # Handle errors
    end
  end

  # PATCH/PUT /blocks/1 or /blocks/1.json
  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to block_url(@block), notice: "Block was successfully updated." }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1 or /blocks/1.json
  def destroy
    @block = current_user.blocked_users.find_by(id: params[:id])
    @blocked_user = @block.blocked if @block.present?

    if @block&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profiles_path(@blocked_user), notice: 'Block removed.' }
      end
    else
      # Handle errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def block_params
      params.require(:block).permit(:blocker_id, :blocked_id)
    end
end
