# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :issues
  has_many :comments
  devise :database_authenticatable, :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:facebook]

  enum role: [:reporter, :moderator, :admin]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, allow_nil: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  scope :role_search, ->(args) { where(role: args) }
  query = lambda do |args|
    where("email like ? OR first_name like ? \
           OR last_name like ?", "%#{args}%", "%#{args}%", "%#{args}%")
  end
  scope :like, query

  acts_as_follower

  def self.from_omniauth(auth)
    where(provider: auth.provider,
          uid: auth.uid).first_or_create(user_params(auth))
  end

  def self.user_params(auth)
    { email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      image_url: auth.info.image,
      role: :reporter }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
