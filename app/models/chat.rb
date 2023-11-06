# == Schema Information
#
# Table name: chats
#
#  id                 :integer          not null, primary key
#  closed_by_receiver :boolean
#  closed_by_sender   :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  receiver_id        :integer
#  sender_id          :integer
#
class Chat < ApplicationRecord

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :messages
end
