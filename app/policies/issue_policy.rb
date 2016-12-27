# frozen_string_literal: true
class IssuePolicy < ApplicationPolicy
  def index?
    user && (user.admin? || user.moderator?)
  end

  def approve?
    user && (user.admin? || user.moderator?)
  end

  def destroy?
    user && (user.admin? || user.moderator?)
  end

  def new?
    user
  end

  def create?
    user
  end
end
