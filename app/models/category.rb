class Category < ApplicationRecord
  has_many :issues
  scope :ordered_by_name, -> { order(:name) }
end
