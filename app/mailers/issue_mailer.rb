# Encoding: utf-8
class IssueMailer < ApplicationMailer
  default from: 'new_issue@newvasjuky.com'

  def issue_created(id)
    @issue = Issue.find(id)
    @user = @issue.user
    @recipients = User.where(role: [:admin, :moderator])
    emails = @recipients.collect(&:email).join(';')
    mail to: emails,
         subject: 'Подано нову скаргу'
  end
end
