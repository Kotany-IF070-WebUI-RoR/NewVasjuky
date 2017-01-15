# Encoding: utf-8
class Issue < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :user
  belongs_to :category
  enum status: [:pending, :declined, :open, :closed]
  REGEXP_NAME = /\p{L}/
  REGEXP_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.\w+\z/i
  REGEXP_PHONE = /\A[ x0-9\+\(\)\-\.]+\z/
  validates :name, :address, :phone, :email, :category_id,
            :description, :user_id, :title,
            presence: true
  validates :location, presence: true,
                       unless: ->(obj) { lat_and_long_present?(obj) }
  validates :name, length: { maximum: 255 },
                   format: { with: REGEXP_NAME,
                             message: 'Ім\'я повинне містити лише літери' }
  validates :phone, length: { maximum: 50 },
                    format: { with: REGEXP_PHONE,
                              message: 'Номер телефону повинен містити лише
                              цифри' }
  validates :email, length: { maximum: 255 },
                    format: { with: REGEXP_EMAIL,
                              message: 'Адреса повинна бути справжньою' }
  validates :description, length: { minimum: 50 }
  mount_uploader :attachment, AttachmentUploader
  scope :ordered, -> { order(created_at: :desc) }
  geocoded_by :location
  after_validation :geocode,
                   if: ->(obj) { obj.location.present? && !obj.latitude? }
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :reverse_geocode,
                   if: ->(obj) { lat_and_long_present?(obj) }

  def lat_and_long_present?(obj)
    obj.latitude.present? && obj.longitude.present?
  end
end
