# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  chat_id    :integer
#
class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
end
