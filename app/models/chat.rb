# == Schema Information
#
# Table name: chats
#
#  id                   :integer          not null, primary key
#  closed_by_receiver   :boolean
#  closed_by_sender     :boolean
#  last_message_sent_at :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  receiver_id          :integer
#  sender_id            :integer
#
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy

  def last_message_date
    messages.order(created_at: :desc).first&.created_at
  end
end
