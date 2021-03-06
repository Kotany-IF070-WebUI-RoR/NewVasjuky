require 'rails_helper'

describe Issue, type: :model do
  subject { create(:issue) }
  let(:reporter) { create(:user, :reporter) }

  before(:each) do
    subject.user_id = reporter.id
  end

  describe 'Name' do
    it 'should be present' do
      subject.name = '   '
      expect(subject).to be_invalid
    end

    it 'should not be to long' do
      subject.name = 'a' * 256
      expect(subject).to be_invalid
    end

    it 'can contain spaces' do
      subject.name = Faker::Name.name_with_middle
      expect(subject).to be_valid
    end
  end

  describe 'Phone' do
    it 'should be present' do
      subject.phone = '    '
      expect(subject).to be_invalid
    end

    it 'should not be too long' do
      subject.phone = '1' * 51
      expect(subject).to be_invalid
    end

    it 'validation should reject invalid phone numbers' do
      invalid_phone = %w(andrew333 444-string pro100)
      invalid_phone.each do |number|
        subject.phone = number
        expect(subject).to be_invalid
      end
    end

    it 'validation should accept valid phone numbers' do
      valid_phone = []
      5.times { valid_phone << Faker::PhoneNumber.phone_number }
      valid_phone.each do |number|
        subject.phone = number
        expect(subject).to be_valid
      end
    end
  end

  describe 'Address' do
    it 'should be present' do
      subject.address = '   '
      expect(subject).to be_invalid
    end
  end

  describe 'Email' do
    it 'should be present' do
      subject.email = '   '
      expect(subject).to be_invalid
    end

    it 'should not be too long' do
      subject.email = '1' * 51
      expect(subject).to be_invalid
    end

    it 'validation should reject invalid email' do
      invalid_email = %w(andrew@333 @444.string pro100 mail@foo.com. mail@.foo)
      invalid_email.each do |email|
        subject.email = email
        expect(subject).to be_invalid
      end
    end

    it 'validation should accept valid email' do
      valid_email = []
      5.times { valid_email << Faker::Internet.email }
      valid_email.each do |email|
        subject.email = email
        expect(subject).to be_valid
      end
    end
  end

  describe 'Description' do
    it 'should be present' do
      subject.description = '   '
      expect(subject).to be_invalid
    end

    it 'should be wide' do
      subject.description = 'a' * 49
      expect(subject).to be_invalid
    end
  end

  describe 'User id' do
    it 'should be present' do
      subject.user_id = nil
      expect(subject).to be_invalid
    end

    it 'should exist and user should be present' do
      expect(subject.user_id).to be_equal User.last.id
    end
  end

  describe 'fb_post' do
    it 'should have location' do
      expect(subject.fb_post[:message]).to include(subject.location)
    end

    it 'should have description' do
      expect(subject.fb_post[:message]).to include(subject.description)
    end

    it 'should have tags' do
      expect(subject.fb_post[:message]).to include(subject.category.tags)
    end

    # it 'should have picture url' do
    #   picture_link = subject.attachment.file.file.partition('uploads').last
    #   expect(subject.fb_post[:picture]).to include(picture_link)
    # end

    it 'should have issue url' do
      url = "#{Rails.application.config.host}/issues/#{subject.id}"
      expect(subject.fb_post[:link]).to include(url)
    end
  end

  describe 'AASM statuses.' do
    describe 'When status change from pending to' do
      let(:issue) { create(:issue) }
      it 'opened' do
        expect(issue).to allow_event :approve
        expect(issue).to_not allow_event :close
        expect(issue).to allow_transition_to(:opened)
        expect(issue).to_not allow_transition_to(:closed)
        expect(issue).to transition_from(:pending)
          .to(:opened).on_event(:approve)
      end

      it 'declined' do
        expect(issue).to allow_event :decline
        expect(issue).to_not allow_event :close
        expect(issue).to allow_transition_to(:declined)
        expect(issue).to_not allow_transition_to(:closed)
        expect(issue).to transition_from(:pending)
          .to(:declined).on_event(:decline)
      end
    end

    describe 'When status change from opened to' do
      let(:issue) { create(:issue, status: :opened) }
      it 'closed' do
        expect(issue).to allow_event :close
        expect(issue).to_not allow_event :open
        expect(issue).to_not allow_event :decline
        expect(issue).to allow_transition_to(:closed)
        expect(issue).to_not allow_transition_to(:opened)
        expect(issue).to_not allow_transition_to(:pending)
        expect(issue).to_not allow_transition_to(:declined)
        expect(issue).to transition_from(:opened)
          .to(:closed).on_event(:close)
      end
    end

    describe 'When status change from declined to' do
      let(:issue) { create(:issue, status: :declined) }
      it 'any' do
        expect(issue).to_not allow_event :close
        expect(issue).to_not allow_event :open
        expect(issue).to_not allow_event :decline
        expect(issue).to_not allow_transition_to(:opened)
        expect(issue).to_not allow_transition_to(:pending)
        expect(issue).to_not allow_transition_to(:decline)
        expect(issue).to_not allow_transition_to(:closed)
      end
    end
  end
end
