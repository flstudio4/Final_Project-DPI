class ChangeNameInChats < ActiveRecord::Migration[7.0]
  def change
    rename_column :chats, :closed_by_reseiver, :closed_by_receiver
  end
end
