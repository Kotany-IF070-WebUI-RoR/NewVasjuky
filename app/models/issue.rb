# Encoding: utf-8
class Issue < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :comments, as: :commentable
  belongs_to :user
  belongs_to :category
  has_many :issue_attachments
  accepts_nested_attributes_for :issue_attachments, allow_destroy: true
  enum status: [:pending, :declined, :open, :closed]
  STATUSES = { 'open' => 'Запит прийнято',
               'pending' => 'Очікує на модерацію',
               'declined' => 'Запит відхилено',
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

  def first_attached_image
    issue_attachments.first_or_initialize.attachment
  end

  def fb_post
    { message: fb_message, link: fb_link,
      name: title.to_s, picture: fb_picture }
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
    picture = first_attached_image.path || 'uploads/default-image.jpg'
    "#{ENV['IMAGE_HOSTING_URL']}#{picture}"
  end

  def post_to_facebook!
    return if Rails.env.test? || posted_on_facebook?
    page = prepare_facebook_page
    page.feed!(fb_post)
    update_attribute('posted_on_facebook', true)
  end

  def prepare_facebook_page
    FbGraph2::Page.new(ENV['FACEBOOK_GROUP_ID'],
                       access_token: ENV['FACEBOOK_GROUP_TOKEN'])
  end
end
