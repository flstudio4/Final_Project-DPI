class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :chat_id
      t.integer :author_id
      t.text :content

      t.timestamps
    end
  end
end
