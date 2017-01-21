# Encoding: utf-8
class IssueMailer < ApplicationMailer
#      create  app/mailers/issue_mailer.rb
#      invoke  slim
#      create    app/views/issue_mailer
#      invoke  rspec
#      create    spec/mailers/issue_mailer_spec.rb
#      create    spec/mailers/previews/issue_mailer_preview.rb
  default template_path: 'mailers/issues'
  default_url_options[:host] = 'localhost:3000'

  def issue_created(saved, user)
    @user = user
    @issue = saved
    @recipients = User.where(role: :admin).or(User.where(role: :moderator))
    emails = @recipients.collect(&:email).join(',')
    mail to: emails,
         subject: 'Подано нову скаргу'
  end
end
