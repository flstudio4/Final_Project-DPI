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
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save {self.email = email.downcase}
  before_save {self.username = username.downcase}
  validates :bio, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :dob, presence: true
  validates :country, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :gender, presence: true

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_chats, class_name: 'Chat', foreign_key: 'receiver_id', dependent: :destroy
  has_many :messages, foreign_key: 'author_id', dependent: :destroy

  before_destroy :destroy_all_related_chats

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

  private

  def destroy_all_related_chats
    # This will trigger the dependent: :destroy for messages within each chat
    Chat.where("sender_id = ? OR receiver_id = ?", self.id, self.id).destroy_all
  end
end
