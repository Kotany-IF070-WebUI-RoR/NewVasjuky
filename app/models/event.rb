class Event < ApplicationRecord
  enum before_status: [:pending, :declined, :opened, :closed], _prefix: :before
  enum after_status: [:pending, :declined, :opened, :closed], _prefix: :after

end
