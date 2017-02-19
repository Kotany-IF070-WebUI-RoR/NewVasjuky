class Category < ApplicationRecord
  has_many :issues
  scope :ordered_by_name, -> { order(:name) }

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
