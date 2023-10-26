json.extract! chat, :id, :sender_id, :receiver_id, :closed_by_sender, :closed_by_reseiver, :created_at, :updated_at
json.url chat_url(chat, format: :json)
