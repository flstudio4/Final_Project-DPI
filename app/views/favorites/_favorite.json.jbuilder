json.extract! favorite, :id, :liking_user_id, :liked_user_id, :created_at, :updated_at
json.url favorite_url(favorite, format: :json)
