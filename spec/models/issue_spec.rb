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

  describe 'fb_message' do
    it 'should have location, description and tags' do
      expect(subject.fb_message).to include(subject.location)
    end

    it 'should have description' do
      expect(subject.fb_message).to include(subject.description)
    end

    it 'should have tags' do
      expect(subject.fb_message).to include(subject.category.tags)
    end
  end

  describe 'fb_picture' do
    it 'should have picture url' do
      expect(subject.fb_picture).to include(ENV['IMAGE_HOSTING_URL'])
    end
  end
end
