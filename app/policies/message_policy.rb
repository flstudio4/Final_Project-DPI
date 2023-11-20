class MessagePolicy < ApplicationPolicy
  def create?
    !Block.exists?(blocker_id: record.chat.receiver_id, blocked_id: user.id)
  end
end
