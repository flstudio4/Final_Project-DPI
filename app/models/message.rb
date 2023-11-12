# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  chat_id    :integer
#
class Message < ApplicationRecord
  after_create :update_chat_last_message_at
  after_destroy :reset_chat_last_message_at

  belongs_to :author, class_name: 'User'
  belongs_to :chat

  private

  def update_chat_last_message_at
    chat.update(last_message_at: created_at)
  end

  def reset_chat_last_message_at
    # Find the most recent message in the chat
    last_message = chat.messages.order(created_at: :desc).first
    # Update the chat's last_message_at to the most recent message's created_at,
    # or nil if there are no more messages
    chat.update(last_message_at: last_message&.created_at)
  end

end
