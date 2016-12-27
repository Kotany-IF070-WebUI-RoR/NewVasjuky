module CheckAdminHelper
  def admin?
    current_user && current_user.admin?
  end

  def admin_or_moderator?
    current_user && (current_user.admin? || current_user.moderator?)
  end
end
