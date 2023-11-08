# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  avatar                 :string
#  bio                    :text
#  city                   :string
#  country                :string
#  dob                    :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  state                  :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save {self.email = email.downcase}
  before_save {self.username = username.downcase}

  validates :bio, length: { maximum: 90, message: "Bio must be less than 91 characters" }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :dob, presence: true
  validates :country, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :gender, presence: true

  has_many :messages
  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id'
  has_many :received_chats, class_name: 'Chat', foreign_key: 'receiver_id'

  scope :age_gt, ->(age) { where("dob <= ?", age.to_i.years.ago.to_date) }
  scope :age_lt, ->(age) { where("dob >= ?", age.to_i.years.ago.to_date) }

  def age
    (Date.today - self.dob).to_i / 365
  end

  def self.ransackable_attributes(auth_object = nil)
    ["state", "city", "country", "age_min", "age_max"]
  end

  def self.ransackable_scopes(auth_object = nil)
    ["age_gt", "age_lt"]
  end
end
