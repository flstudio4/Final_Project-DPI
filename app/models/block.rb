# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blocked_id :integer
#  blocker_id :integer
#
class Block < ApplicationRecord
  validates :blocked_id, uniqueness: { scope: :blocker_id }
  validates :blocker_id, presence: true

  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'
end
