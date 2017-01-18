# Encoding: utf-8
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :title,
            length: { maximum: 150, too_long: 'Заголовок надто довгий.
 Максимум %{count} символів' }, presence: true
  validates :content,
            length: { maximum: 3000, too_long: 'Коментар надто довгий.
 Максимум %{count} символів' },
            presence: true
  scope :ordered, -> { order(created_at: :desc) }

  def can_delete?(user)
    return false if user.nil?
    (user_id == user.id) || user.admin? || user.moderator?
  end
end
