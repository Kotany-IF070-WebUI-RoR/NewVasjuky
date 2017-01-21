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
      #sign_in reporter
      #post :create,
      #     params: { issue: attributes_for(:issue, category_id: category.id) }
      #expect(mail.subject).to eq('Подано нову скаргу')

      #sign_in reporter
      #post :create
      expect(mail.subject).to eq('Подано нову скаргу')
    end

    it 'renders the receiver email' do
      @recipients = User.where(role: :admin).or(User.where(role: :moderator))
      #byebug
      expect(mail.to).to eq(@recipients.collect(&:email))
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['new_issue@newvasjuky.com'])
    end

    it 'assigns @issue and @user' do
      #mail
      #byebug
      expect(mail.text_part.body.to_s.force_encoding('UTF-8')).to match(reporter.full_name)
    end
  end
end
