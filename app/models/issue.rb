# Encoding: utf-8
class Issue < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :comments, as: :commentable
  belongs_to :user
  belongs_to :category
  enum status: [:pending, :declined, :open, :closed]
  STATUSES = { 'open' => 'Запит прийнято',
               'pending' => 'Очікує на модерацію',
               'declined' => 'Запит відмовлено',
               'closed' => 'Запит вирішено' }.freeze
  REGEXP_NAME = /\p{L}/
  REGEXP_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.\w+\z/i
  REGEXP_PHONE = /\A[ x0-9\+\(\)\-\.]+\z/
  validates :name, :address, :phone, :email, :category_id,
            :description, :user_id, :title,
            presence: true
  validates :location, presence: true,
                       unless: ->(obj) { lt_ln_present?(obj) }
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
  scope :approved, -> { where(status: :open) }
  scope :closed, -> { where(status: :closed) }
  geocoded_by :location
  after_validation :geocode,
                   if: ->(obj) { obj.location.present? && !obj.latitude? }
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :reverse_geocode,
                   if: ->(obj) { !obj.location.present? && lt_ln_present?(obj) }

  acts_as_followable

  def lt_ln_present?(obj)
    obj.latitude.present? && obj.longitude.present?
  end

  def status_name
    STATUSES[status]
  end

  def published?
    %w(open closed).include? status
  end

  def can_read_when_unpublished?(user)
    user.admin? || user.moderator? || (self.user == user)
  end

  def can_read?(user)
    published? || can_read_when_unpublished?(user)
  end

  def fb_post
    { message: fb_message, link: fb_link, name: title.to_s,
      picture: fb_picture }
  end

  def fb_message
    fb_location = location.blank? ? '' : "Адреса: #{location} \n \n"
    fb_description = description.blank? ? '' : "Опис: #{description} \n \n"
    tags = category.tags.blank? ? '' : category.tags.to_s
    [fb_location, fb_description, tags].reject(&:blank?).join(' ')
  end

  def fb_link
    issue_url(self, host: Rails.application.config.host)
  end

  def fb_picture
    picture = attachment.file.nil? ? '/uploads/default-image.jpg' : attachment
    "#{ENV['IMAGE_HOSTING_URL']}#{picture}"
  end
end
