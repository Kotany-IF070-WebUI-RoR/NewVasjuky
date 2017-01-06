# Encoding: utf-8
class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :category
  REGEXP_NAME = /\p{L}/
  REGEXP_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.\w+\z/i
  REGEXP_PHONE = /\A[ x0-9\+\(\)\-\.]+\z/
  validates :name, :address, :phone, :email, :category_id,
            :description, :user_id, :location, :title,
            presence: true
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
end
