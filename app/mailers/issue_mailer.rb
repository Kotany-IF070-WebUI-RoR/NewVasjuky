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
    @follower_emails = @issue.followers(User).pluck(:email)
    return unless @follower_emails.any?
    mail to: @follower_emails.join(';'), subject: 'Змінено статус скарги'
  end
end
