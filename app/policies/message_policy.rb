class MessagePolicy < ApplicationPolicy
  def create?
    # Check if the user is part of the chat (either as sender or receiver)
    is_participant = record.chat.sender_id == user.id || record.chat.receiver_id == user.id

    # Check if the user is not blocked by the receiver
    not_blocked = !Block.exists?(blocker_id: record.chat.receiver_id, blocked_id: user.id)

    # Allow message creation if the user is a participant and not blocked
    is_participant && not_blocked
  end
end
