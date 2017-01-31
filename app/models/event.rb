# Encoding: utf-8
class Event < ApplicationRecord
  enum before_status: [:pending, :declined, :opened, :closed], _prefix: :before
  enum after_status: [:pending, :declined, :opened, :closed], _prefix: :after
  belongs_to :issue


  STATUSES = { 'opened' => 'підтверджено, очікує вирішення',
               'pending' => 'Очікує на модерацію',
               'declined' => 'відхилено модератором',
               'closed' => 'виріщено' }.freeze

  scope :ordered, -> { order(created_at: :desc) }
  scope :public_events, -> { where(after_status: [:opened, :closed]) }

  def before_status_full
    STATUSES[before_status]
  end

  def after_status_full
    STATUSES[after_status]
  end
end
