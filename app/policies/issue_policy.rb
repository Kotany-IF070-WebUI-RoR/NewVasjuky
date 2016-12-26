# frozen_string_literal: true
class IssuePolicy < ApplicationPolicy
  def new?
    user.reporter?
  end

  def create?
    user.reporter?
  end
end
