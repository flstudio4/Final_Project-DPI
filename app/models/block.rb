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
  belongs_to :blocker, class_name: 'User', foreign_key: 'blocker_id'
  belongs_to :blocked_user, class_name: 'User', foreign_key: 'blocked_id'
end
