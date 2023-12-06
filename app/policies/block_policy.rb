class BlockPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    record.blocker_id == user.id
  end
end
