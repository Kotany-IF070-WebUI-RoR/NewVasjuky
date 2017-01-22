# Encoding: utf-8
class IssueMailer < ApplicationMailer\
  default template_path: 'mailers/issues'
  default_url_options[:host] = 'localhost:3000'

  def issue_created(issue, user)
    @user = user
    @issue = issue
    @recipients = User.where(role: :admin).or(User.where(role: :moderator))
    emails = @recipients.collect(&:email).join(',')
    mail to: emails,
         subject: 'Подано нову скаргу'
  end
end
