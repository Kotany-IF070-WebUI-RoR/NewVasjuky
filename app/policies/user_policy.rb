# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def index?
    user && (user.admin? || user.moderator?)
  end

  def change_role?
    return false if record.admin?
    user.admin?
  end

  def toggle_ban?
    return false unless record.reporter?
    user.admin? || user.moderator?
  end
end
