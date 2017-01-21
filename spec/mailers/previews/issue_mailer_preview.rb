class IssueMailerPreview < ActionMailer::Preview
  def issue_created
    @user = User.first
    @issue = Issue.first
    IssueMailer.issue_created(@issue, @user)
  end
end
