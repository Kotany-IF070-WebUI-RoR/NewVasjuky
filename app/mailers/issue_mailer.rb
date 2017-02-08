# Encoding: utf-8
class IssueMailer < ApplicationMailer
  def issue_created(id)
    @issue = Issue.find(id)
    @user = @issue.user
    @recipients = User.where(role: [:admin, :moderator])
    emails = @recipients.collect(&:email).join(';')
    mail to: emails,
         subject: 'Подано нову скаргу'
  end

  def issue_status_changed(id)
    @issue = Issue.find(id)
    @reporter_email = @issue.user.email
    @followers_ids = Follow.find_followers(id).pluck(:follower_id)
    return unless @followers_ids.any?
    emails = User.find(@followers_ids).pluck(:email).join(';')
    mail to: emails, subject: 'Змінено статус скарги'
  end
end
