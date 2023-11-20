class ChatPolicy < ApplicationPolicy
  def show?
    record.sender_id == user.id || record.receiver_id == user.id
  end
end