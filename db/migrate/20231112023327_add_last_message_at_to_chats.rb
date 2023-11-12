class AddLastMessageAtToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :last_message_at, :datetime
    add_index :chats, :last_message_at
  end
end
