class IssueMailerPreview < ActionMailer::Preview
  def issue_created
    @issue = Issue.first
    IssueMailer.issue_created(@issue.id)
  end
end
