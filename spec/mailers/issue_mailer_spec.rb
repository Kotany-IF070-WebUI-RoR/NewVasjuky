# Encoding: utf-8
require 'rails_helper'

describe IssueMailer, type: :mailer do
  let(:reporter) { create(:user, :reporter) }
  let(:issue) { create(:issue) }
  let(:category) { create(:category) }
  let(:mail) { IssueMailer.issue_created(issue, reporter).deliver }

  before :each do
    create(:user, :admin)
    create(:user, :moderator)
  end

  describe 'When issue was created mailer' do
    it 'renders the subject' do
      expect(mail.subject).to eq('Подано нову скаргу')
    end

    it 'renders the receiver email' do
      @recipients = User.where(role: :admin).or(User.where(role: :moderator))
      expect(mail.to).to eq(@recipients.collect(&:email))
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['new_issue@newvasjuky.com'])
    end

    it 'generates the correct content in plain-text' do
      expect(mail.text_part.body.to_s.force_encoding('UTF-8')).to \
        match("Користувач #{reporter.full_name} подав нову скаргу.")
    end

    it 'generates the correct content in HTML' do
      expect(mail.html_part.body.to_s.force_encoding('UTF-8')).to \
        include(issue_url(issue))
        .and include(issue.title)
        .and include(issue.description)
    end
  end
end
