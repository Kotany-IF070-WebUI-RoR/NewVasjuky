# Encoding: utf-8
class Category < ApplicationRecord
  has_many :issues
  scope :ordered_by_name, -> { order(:name) }

  REGEXP_NAME = /\A[[:alnum:] ,-]*\z/
  REGEXP_TAGS = /\A[[:alnum:] _]*\z/

  validates :name, :description, :tags,
            presence: true
  validates :name, length: { minimum: 5, maximum: 100 },
                   format: { with: REGEXP_NAME,
                             message: 'Назва може містити тільки
                                       літери і цифри' }
  validates :description, length: { minimum: 20, maximum: 300 }
  validates :tags, length: { minimum: 2, maximum: 100 },
                   format: { with: REGEXP_TAGS,
                             message: 'Теги можуть містити тільки
                                       літери, цифри і знак _.
                                       Розділяти теги потрібно пробілом.' }

  def name=(s)
    self[:name] = s.to_s.capitalize
  end

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

  def self.calculate(id, scope)
    joins(:issues).select('categories.*')
                  .where('categories.id = ? AND issues.status = ?',
                         Category.find(id), Issue.statuses[scope])
                  .calculate(:count, :all)
  end
end
