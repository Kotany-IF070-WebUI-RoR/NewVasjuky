require 'rails_helper'

describe Category, type: :model do
  subject { create(:category) }
  let(:admin) { create(:user, :admin) }

  describe 'name' do
    it 'should be present' do
      subject.name = '   '
      expect(subject).to be_invalid
    end

    it 'should not be too short' do
      subject.name = 'a' * 4
      expect(subject).to be_invalid
    end

    it 'should not be too long' do
      subject.name = 'a' * 101
      expect(subject).to be_invalid
    end

    it 'validation should not accept invalid names' do
      subject.name = 'name#'
      expect(subject).to be_invalid
      subject.name = 'name$'
      expect(subject).to be_invalid
      subject.name = 'name!'
      expect(subject).to be_invalid
      subject.name = 'name_'
      expect(subject).to be_invalid
      subject.name = 'name.'
      expect(subject).to be_invalid
    end

    it 'may contain letters, numbers, spaces, commas and hyphens' do
      subject.name = 'Category name'
      expect(subject).to be_valid
      subject.name = '911 service'
      expect(subject).to be_valid
      subject.name = 'Questions, answers'
      expect(subject).to be_valid
      subject.name = 'Questions-answers'
      expect(subject).to be_valid
    end
  end

  describe 'description' do
    it 'should be present' do
      subject.description = '   '
      expect(subject).to be_invalid
    end

    it 'should not be too short' do
      subject.description = 'a' * 29
      expect(subject).to be_invalid
    end

    it 'should not be too long' do
      subject.description = 'a' * 301
      expect(subject).to be_invalid
    end
  end

  describe 'tags' do
    it 'should be present' do
      subject.tags = '   '
      expect(subject).to be_invalid
    end

    it 'should not be too short' do
      subject.tags = 'a'
      expect(subject).to be_invalid
    end

    it 'should not be to long' do
      subject.tags = 'a' * 101
      expect(subject).to be_invalid
    end

    it 'validation should not accept invalid names' do
      subject.tags = '#hashtag'
      expect(subject).to be_invalid
      subject.tags = 'hash-tag'
      expect(subject).to be_invalid
      subject.tags = 'hashtag!'
      expect(subject).to be_invalid
      subject.tags = 'hashtag$'
      expect(subject).to be_invalid
      subject.tags = 'hashtag,'
      expect(subject).to be_invalid
    end

    it 'may contain letters, numbers, spaces and underscores' do
      subject.tags = 'Firsttag secondtag'
      expect(subject).to be_valid
      subject.tags = '1tag'
      expect(subject).to be_valid
      subject.tags = 'First_tag'
      expect(subject).to be_valid
    end
  end
end
