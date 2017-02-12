# Encoding: utf-8
# frozen_string_literal: true
module ApplicationHelper
  def admin?
    return true if current_user.admin?
    access_denied
  end

  def moderator?
    return true if current_user.moderator?
    access_denied
  end

  def admin_or_moderator?
    return true if current_user.admin? || current_user.moderator?
    access_denied
  end

  def bann_user(user)
    return unless admin_or_moderator? && user.reporter?
    toggle_phrase = user.banned? ? 'Розблокувати' : 'Заблокувати'
    render 'account/admin/users/bann_user', user: user, phrase: toggle_phrase
  end

  def admin_change_role(user)
    if current_user.admin? && !user.admin?
      render 'account/admin/users/change_role', user: user
    else
      render plain: user.role.to_s
    end
  end

  def access_denied
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'Доступ заборонено'
  end

  def issue_listing(issues)
    issues = issue_status_select(issues) if params[:issue_status]
    issues = issues.find_issues(params[:filter]) if params[:filter]
    smart_listing_create :issues, issues,
                         sort_attributes: [
                           [:created_at, 'issues.created_at'],
                           [:title, 'issues.title'],
                           [:status, 'issues.status'],
                           [:user, 'users.first_name']
                         ],
                         default_sort: { created_at: 'desc' }, partial: 'issue'
  end

  def issue_status_select(issues)
    params[:issue_status].empty? ? issues : issues.status(params[:issue_status])
  end
end
