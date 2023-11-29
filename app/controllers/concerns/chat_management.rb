module ChatManagement
  extend ActiveSupport::Concern

  def send_message(receiver_id)
    current_user_id = current_user.id

    # Prevent sending message to self
    return if receiver_id == current_user_id

    # Find or create chat
    chat = find_or_create_chat(current_user_id, receiver_id)

    # Redirect to chat's show page
    redirect_to chat_path(chat)
  end

  private

  def find_or_create_chat(sender_id, receiver_id)
      Chat.find_by(sender_id: sender_id, receiver_id: receiver_id) ||
      Chat.find_by(sender_id: receiver_id, receiver_id: sender_id) ||
      Chat.create(sender_id: sender_id, receiver_id: receiver_id, last_message_at: Time.current)
  end
end
