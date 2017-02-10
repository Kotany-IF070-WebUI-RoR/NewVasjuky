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

  def self.issue_status_changed(id)
    @issue = Issue.find(id)
    @followers = @issue.followers(User)
    return unless @followers.any?
    @followers.each do |follower|
      mail_to_followers(follower, @issue).deliver
    end
  end

  def mail_to_followers(follower, issue)
    @follower = follower
    @issue = issue
    mail to: @follower.email, subject: 'Змінено статус скарги'
  end
end
