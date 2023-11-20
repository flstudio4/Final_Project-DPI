# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  avatar                 :string
#  bio                    :text
#  city                   :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  country                :string
#  dob                    :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  state                  :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  before_save {self.email = email.downcase}
  before_save {self.username = username.downcase}

  before_update :remove_old_avatar, if: :avatar_changed?
  before_destroy :remove_avatar_from_cloudinary
  before_destroy :destroy_all_related_chats

  validate :at_least_18_years_old
  validate :less_than_100_years_old
  validates :dob, presence: true

  validates :avatar, presence: true, on: :create
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :country, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :gender, presence: true
  validates :name, presence: true

  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_chats, class_name: 'Chat', foreign_key: 'receiver_id', dependent: :destroy
  has_many :messages, foreign_key: 'author_id', dependent: :destroy

  has_many :blocked_users, class_name: 'Block', foreign_key: 'blocker_id', dependent: :destroy
  has_many :blockers, class_name: 'Block', foreign_key: 'blocked_id', dependent: :destroy

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

  def at_least_18_years_old
    return if dob.blank?
    if dob > 18.years.ago.to_date
      errors.add(:dob, 'You must be at least 18 years old.')
    end
  end

  def less_than_100_years_old
    return if dob.blank?
    if dob < 100.years.ago.to_date
      errors.add(:dob, 'You are too old for dating.')
    end
  end

  def destroy_all_related_chats
    # This will trigger the dependent: :destroy for messages within each chat
    Chat.where("sender_id = ? OR receiver_id = ?", self.id, self.id).destroy_all
  end

  def remove_avatar_from_cloudinary
    # CarrierWave's Cloudinary integration provides a public_id method on the uploader.
    if self.avatar? && self.avatar.file
      public_id = self.avatar.file.public_id
      Cloudinary::Uploader.destroy(public_id) if public_id.present?
    end
  rescue Cloudinary::Api::Error => e
    Rails.logger.error "Cloudinary deletion failed: #{e.message}"
  end

  def remove_old_avatar
    if avatar_was.present?
      old_public_id = extract_public_id(avatar_was)
      Rails.logger.info "Attempting to delete Cloudinary image with public ID: #{old_public_id}"
      Cloudinary::Uploader.destroy(old_public_id) if old_public_id.present?
    end
  rescue Cloudinary::Api::Error => e
    Rails.logger.error "Cloudinary deletion failed: #{e.message}"
  end

  def extract_public_id(url_or_id)
    # Extract the public ID from the URL if necessary
    # This is a placeholder implementation; adjust as per your app's logic
    url_or_id.split('/').last.split('.').first
  end
end
