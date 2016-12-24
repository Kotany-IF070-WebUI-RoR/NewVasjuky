# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def index?
    user && (user.admin? || user.moderator?)
  end
end
