# Encoding: utf-8
# frozen_string_literal: true
module ApplicationHelper
  def admin?
    return true if current_user && current_user.admin?
    access_denied
  end

  def moderator?
    return true if current_user && current_user.moderator?
    access_denied
  end

  def admin_or_moderator?
    return true if current_user &&
                   (current_user.admin? || current_user.moderator?)
    access_denied
  end

  def access_denied
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'Доступ заборонено'
  end
end
