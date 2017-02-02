class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event
  scope :later_than, ->(date) { where('created_at > ?', date) }
  scope :unread, -> { where(readed: false) }
  scope :by_events_id, ->(event_id) { where(event_id: event_id) }

  def mark_as_readed
    update_attribute(:readed, true) unless readed
  end
end
