class Event < ApplicationRecord
  include Statuses
  enum before_status: STATUSES_SYM, _prefix: :before
  enum after_status: STATUSES_SYM, _prefix: :after
  belongs_to :issue
  has_many :notifications
  after_create :create_notifications
  validates :issue_id, :before_status, :after_status,
            presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :public_events, -> { where(after_status: [:opened, :closed]) }

  def before_status_full
    STATUSES[before_status]
  end

  def after_status_full
    STATUSES[after_status]
  end

  def new_for?(user)
    notifications.where('created_at > ? and user_id = ?',
                        user.last_check_notifications_at, user.id).present?
  end

  def unread_by?(user)
    notifications.unread.find_by(user_id: user.id).present?
  end

  private

  def create_notifications
    users = issue.followers(User)
    notifications = []
    users.each do |u|
      notifications << u.notifications.new(event_id: id) unless u.id == author_id
    end
    Notification.import(notifications)
  end
end
