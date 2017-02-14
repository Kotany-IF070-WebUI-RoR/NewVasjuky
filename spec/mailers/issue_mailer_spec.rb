# Encoding: utf-8
require 'rails_helper'
require 'byebug'

describe IssueMailer, type: :mailer do
  let(:reporter)   { create(:user, :reporter) }
  let!(:admin)     { create(:user, :admin) }
  let!(:email)     { admin.email }
  let!(:moderator) { create(:user, :moderator) }
  let!(:issue)     { create(:issue) }
  let(:category)   { create(:category) }
  let(:mail_on_created)      { IssueMailer.issue_created(issue.id).deliver! }
  let(:issue_status_changed) { IssueMailer.issue_status_changed(issue.id) }
  let(:mail_to_fllwr) { IssueMailer.mail_to_followers(email, issue).deliver! }

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

  describe 'mail_to_multiple_followers' do
    before do
      @followers = [admin, moderator]
      @followers.each { |follower| follower.follow!(issue) }
    end

    describe '#issue_status_changed' do
      before do
        @emails = IssueMailer.issue_status_changed(issue.id)
      end

      it 'finds all recipients when issue changed its status' do
        expect @emails =~ @followers.collect(&:email)
      end

      it 'finds no recipients when issue has no followers' do
        @followers.each { |follower| follower.unfollow!(issue) }
        expect(issue_status_changed).to be_nil
      end
    end

    describe '#mail_to_followers' do
      before do
        ResqueSpec.reset!
        IssueMailer.mail_to_followers(email, issue).deliver
      end

      it 'added to the queue' do
        expect(IssueMailer).to have_queue_size_of(1)
        expect(IssueMailer)
          .to have_queued(:mail_to_followers, [email, issue])
      end

      it 'renders the subject' do
        expect(mail_to_fllwr.subject).to eq('Змінено статус скарги')
      end

      it 'generates the correct content in HTML' do
        expect(mail_to_fllwr.body.to_s.force_encoding('UTF-8')).to \
          include(issue_url(issue))
          .and include(admin.first_name)
          .and include(issue.title)
      end
    end
  end
end
