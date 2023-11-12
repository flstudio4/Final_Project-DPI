class AddLastMessageSentAtToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :last_message_sent_at, :datetime
  end
end
