# Encoding: utf-8
class Category < ApplicationRecord
  has_many :issues
  scope :ordered_by_name, -> { order(:name) }

  REGEXP_NAME = /\A[[:alnum:] ,-]*\z/
  REGEXP_TAGS = /\A[[:alnum:] _]*\z/

  validates :name, :description, :tags,
            presence: true
  validates :name, uniqueness: { case_sensitive: false },
                   length: { minimum: 5, maximum: 100 },
                   format: { with: REGEXP_NAME,
                             message: 'Назва може містити тільки
                                       літери, цифри, коми і дефіс.' }
  validates :description, length: { minimum: 20, maximum: 300 }
  validates :tags, length: { minimum: 2, maximum: 100 },
                   format: { with: REGEXP_TAGS,
                             message: 'Теги можуть містити тільки
                                       літери, цифри і знак _.
                                       Розділяти теги потрібно пробілом.' }

  def self.statistics_for(day_range, scope)
    stat_filter(day_range, scope).calculate(:count, :all)
                                 .sort_by { |_key, value| value }.to_h
                                 .transform_keys do |key|
                                   Category.find(key).name
                                 end
  end

  def self.stat_filter(day_range, scope)
    joins(:issues).select('categories.*')
                  .where('issues.created_at > ? AND issues.status in (?, ?)',
                         day_range.days.ago,
                         Issue.statuses[scope[0]], Issue.statuses[scope[1]])
                  .group('categories.id')
  end

  def calculate(status)
    issues.where(status: status).count
  end

  def issues_list(status, filter)
    issues.ordered.where(status: status).like(filter)
  end
end
