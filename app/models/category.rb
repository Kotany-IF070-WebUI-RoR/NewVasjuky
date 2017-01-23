class Category < ApplicationRecord
  has_many :issues
  scope :by_name, -> { order(:name) }
end
