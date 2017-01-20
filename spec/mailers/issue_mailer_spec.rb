# Encoding: utf-8
require 'rails_helper'

describe IssueMailer, type: :mailer do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:issue) { build(:issue) }
  let(:mail) { IssueMailer.issue_created }

  describe 'When issue was created mailer' do
    it 'renders the subject' do
      sign_in reporter
      post :create
      expect(mail.subject).to eq('Подано нову скаргу')
    end
  end
end
