class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  def voted?
    where("user_id=#{current_user.id}").count == 1
  end
end
