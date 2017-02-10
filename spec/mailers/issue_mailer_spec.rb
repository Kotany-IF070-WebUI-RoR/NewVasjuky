# Encoding: utf-8
require 'rails_helper'

describe IssueMailer, type: :mailer do
  let(:reporter)  { create(:user, :reporter) }
  let(:admin)     { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let!(:issue)    { create(:issue) }
  let(:category)  { create(:category) }
  let(:mail_on_created) { IssueMailer.issue_created(issue.id).deliver! }
  let(:mail_status_chng) { IssueMailer.issue_status_changed(issue.id).deliver! }

  before :each do
    @followers = [admin, moderator]
  end

  describe '#issue_created' do
    before do
      ResqueSpec.reset!
      IssueMailer.issue_created(issue.id).deliver
    end

    it 'added to the queue' do
      expect(IssueMailer).to have_queue_size_of(1)
      expect(IssueMailer).to have_queued(:issue_created, [issue.id])
    end
  end

  describe 'When issue was created mailer' do
    it 'renders the subject' do
      expect(mail_on_created.subject).to eq('Подано нову скаргу')
    end

    it 'renders the receivers emails' do
      @recipients = User.where(role: [:admin, :moderator])
      expect(mail_on_created.to).to eq(@recipients.collect(&:email))
    end

    it 'renders the sender email' do
      expect(mail_on_created.from).to eq(['noreply@newvasjuky.com'])
    end

    it 'generates the correct content in HTML' do
      expect(mail_on_created.body.to_s.force_encoding('UTF-8')).to \
        include(issue_url(issue))
        .and include(issue.title)
        .and include(issue.description)
    end
  end

  describe '#issue_status_changed' do
    before do
      @followable = issue
      @followable.user.follow!(@followable)
      @followers.each { |follower| follower.follow!(@followable) }
      ResqueSpec.reset!
      IssueMailer.issue_status_changed(issue.id).deliver
    end

    xit 'added to the queue' do
      expect(IssueMailer).to have_queue_size_of(1)
      expect(IssueMailer).to have_queued(:issue_status_changed, [issue.id])
    end

    xit 'renders the subject' do
      expect(mail_status_chng.subject).to eq('Змінено статус скарги')
    end

    xit 'renders the receivers emails' do
      receivers_emails = [@followable.user.email]
                         .concat(@followers.map(&:email))
      expect(mail_status_chng.to).to eq(receivers_emails)
    end

    xit 'generates the correct content in HTML' do
      expect(mail_status_chng.body.to_s.force_encoding('UTF-8')).to \
        include(issue_url(issue))
        .and include(issue.title)
        .and include(issue.status_name)
    end
  end
end
