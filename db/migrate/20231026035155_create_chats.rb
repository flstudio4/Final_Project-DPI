class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :closed_by_sender
      t.boolean :closed_by_reseiver

      t.timestamps
    end
  end
end
