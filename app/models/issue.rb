# Encoding: utf-8
class Issue < ApplicationRecord
  include Rails.application.routes.url_helpers
  include AASM
  include Statuses
  include Facebook
  acts_as_followable

  has_many :comments, as: :commentable
  has_many :votes, as: :voteable
  belongs_to :user
  belongs_to :category, counter_cache: :issues_count
  has_many :issue_attachments
  has_many :events

  accepts_nested_attributes_for :issue_attachments, allow_destroy: true
  enum status: STATUSES_SYM

  REGEXP_NAME = /\p{L}/
  REGEXP_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.\w+\z/i
  REGEXP_PHONE = /\A[ x0-9\+\(\)\-\.]+\z/

  validates :name, :address, :phone, :email, :category_id,
            :description, :user_id, :title,
            presence: true
  validates :location, presence: true,
                       unless: ->(obj) { lt_ln_present?(obj) }
  validates :name, length: { minimum: 4, maximum: 255 },
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
  scope :approved, -> { where(status: :opened) }
  scope :closed, -> { where(status: :closed) }
  scope :status, ->(a) { where(status: a) }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :declined
    state :opened
    state :closed

    event :approve do
      transitions from: :pending, to: :opened
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :close do
      transitions from: :opened, to: :closed
    end
  end

  geocoded_by :location
  after_validation :geocode,
                   if: ->(obj) { obj.location.present? && !obj.latitude? }
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :reverse_geocode,
                   if: ->(obj) { !obj.location.present? && lt_ln_present?(obj) }
  after_create :notify_support

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
    %w(opened closed).include? status
  end

  def self.moderation_list
    joins(:user).select('issues.*, users.first_name, users.last_name')
  end

  def self.find_issues(search_query)
    where('title ilike :arg OR users.last_name ilike :arg',
          arg: "%#{search_query}%")
  end

  def self.like(search_query)
    where('title ilike :arg OR description ilike :arg OR location ilike :arg',
          arg: "%#{search_query}%")
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

  def self.statistics_for(period, group, scope)
    where(status: scope)
      .group_by_period(group, :created_at, range: period).count
  end

  def create_event(event)
    event.before_status = aasm.from_state
    event.after_status = aasm.to_state
    event.save!
  end
end
