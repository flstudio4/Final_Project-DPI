class RemoveClosedByReceiverFromChats < ActiveRecord::Migration[7.0]
  def change
    remove_column :chats, :closed_by_receiver
    remove_column :chats, :closed_by_sender
  end
end
