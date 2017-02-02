# Encoding: utf-8
class Issue < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Search
  include Facebook
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
            :description, :user_id, :title, presence: true
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
  validates :description, length: { minimum: 50, maximum: 3000 }
  validates :title, length: { minimum: 10, maximum: 80 }
  scope :ordered, -> { order(created_at: :desc) }
  scope :approved, -> { where(status: :open) }
  scope :closed, -> { where(status: :closed) }
  scope :find_issues, ->(a) { where('title like ?', "%#{a}%") }
  scope :status, ->(a) { where(status: a) }
  query = search('title like ? OR description like ? OR location like ?')
  scope :like, query
  geocoded_by :location
  after_validation :geocode,
                   if: ->(obj) { obj.location.present? && !obj.latitude? }
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :reverse_geocode,
                   if: ->(obj) { !obj.location.present? && lt_ln_present?(obj) }
  after_create :notify_support
  acts_as_followable

  def lt_ln_present?(obj)
    obj.latitude.present? && obj.longitude.present?
  end

  def status_name
    STATUSES[status]
  end

  def self.status_attributes_for_select
    m_name = model_name.i18n_key
    statuses.map do |status, _|
      [I18n.t("activerecord.attributes.#{m_name}.statuses.#{status}"), status]
    end
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

  def notify_support
    IssueMailer.issue_created(id).deliver
  end

  def prepare_facebook_page
    FbGraph2::Page.new(ENV['FACEBOOK_GROUP_ID'],
                       access_token: ENV['FACEBOOK_GROUP_TOKEN'])
  end
end
