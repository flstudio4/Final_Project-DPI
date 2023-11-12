class RemoveLastMessageSentAtFromChats < ActiveRecord::Migration[7.0]
  def change
    remove_column :chats, :last_message_sent_at
  end
end
