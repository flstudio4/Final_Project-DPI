json.extract! block, :id, :blocker_id, :blocked_id, :created_at, :updated_at
json.url block_url(block, format: :json)
