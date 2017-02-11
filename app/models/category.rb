class Category < ApplicationRecord
  has_many :issues
  scope :ordered_by_name, -> { order(:name) }

  def self.statistics_for(day_range, scope)
    stat_filter(day_range, scope).group('categories.id').calculate(:count, :all)
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
  end
end
