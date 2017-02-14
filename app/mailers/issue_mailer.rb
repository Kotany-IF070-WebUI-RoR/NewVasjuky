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

  def mail_to_followers(email, issue)
    @follower = User.find_by(email: email)
    @issue = issue
    mail to: email, subject: 'Змінено статус скарги'
  end

  def self.issue_status_changed(id)
    @issue = Issue.find(id)
    @followers = @issue.followers(User)
    return unless @followers.any?
    emails = @followers.pluck(:email)
    emails.each do |email|
      mail_to_followers(email, @issue).deliver
    end
  end
end
