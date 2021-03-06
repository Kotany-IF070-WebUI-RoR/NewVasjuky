class Event < ApplicationRecord
  include Statuses
  enum before_status: STATUSES_SYM, _prefix: :before
  enum after_status: STATUSES_SYM, _prefix: :after
  mount_uploader :image, EventUploader
  belongs_to :issue
  has_many :notifications
  after_create :create_notifications, :mail_on_issue_status_changed

  scope :ordered, -> { order(created_at: :desc) }
  scope :public_events, -> { where(after_status: [:opened, :closed]) }
  validates :image, file_size: { less_than: 8.megabytes }
  validates :description, length: { maximum: 2000 }

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

  def details?
    image.present? || description.present?
  end

  def public?
    %w(opened closed).include?(after_status)
  end

  private

  def mail_on_issue_status_changed
    IssueMailer.issue_status_changed(issue.id)
  end

  def create_notifications
    users = issue.followers(User)
    notifications = []
    users.each do |u|
      unless u.id == author_id
        notifications << u.notifications.new(event_id: id)
      end
    end
    Notification.import(notifications)
  end
end
