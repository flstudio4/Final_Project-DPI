# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  last_message_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  receiver_id     :integer
#  sender_id       :integer
#
# Indexes
#
#  index_chats_on_last_message_at  (last_message_at)
#
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  default_scope { order(last_message_at: :desc) }

  def last_message_date
    messages.order(created_at: :desc).first&.created_at
  end
end
