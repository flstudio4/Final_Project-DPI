# == Schema Information
#
# Table name: chats
#
#  id                 :integer          not null, primary key
#  closed_by_reseiver :boolean
#  closed_by_sender   :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  receiver_id        :integer
#  sender_id          :integer
#
class Chat < ApplicationRecord
end
