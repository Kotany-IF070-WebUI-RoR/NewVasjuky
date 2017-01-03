# Encoding: utf-8
# frozen_string_literal: true
module ApplicationHelper
  def admin?
    return if current_user && current_user.admin?
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'Доступ заборонено'
  end

  def moderator?
    return if current_user && current_user.moderator?
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'Доступ заборонено'
  end

  def admin_or_moderator?
    return if current_user && (current_user.admin? || current_user.moderator?)
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'Доступ заборонено'
  end
end
