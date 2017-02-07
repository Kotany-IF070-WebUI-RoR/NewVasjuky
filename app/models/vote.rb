class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  def voted?
    result = where("user_id=#{current_user.id}")
    result.count == 1
  end
end
