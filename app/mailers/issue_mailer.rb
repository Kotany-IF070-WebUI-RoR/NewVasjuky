# Encoding: utf-8
class IssueMailer < ApplicationMailer
  default from: 'new_issue@newvasjuky.com'

  def issue_created(issue_id, user_id)
    @user = User.find(user_id)
    @issue = Issue.find(issue_id)
    @recipients = User.where(role: [:admin, :moderator])
    emails = @recipients.collect(&:email).join(',')
    mail to: emails,
         subject: 'Подано нову скаргу'
  end
end
