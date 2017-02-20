require 'rails_helper'

describe Category, type: :model do
  subject { create(:category) }
  let(:admin) { create(:user, :admin) }

  describe 'name' do
    it 'should be present' do
      subject.name = '   '
      expect(subject).to be_invalid
    end

    it 'should not be to long' do
      subject.name = 'a' * 51
      expect(subject).to be_invalid
    end

    it 'should not accept invalid names' do
      subject.name = 'names#'
      expect(subject).to be_invalid
      subject.name = 'name$'
      expect(subject).to be_invalid
    end

    it 'can contain spaces' do
      subject.name = 'First second'
      expect(subject).to be_valid
    end
  end

  describe 'tags' do
    it 'should be present' do
      subject.tags = '   '
      expect(subject).to be_invalid
    end

    it 'should not be to long' do
      subject.tags = 'a' * 101
      expect(subject).to be_invalid
    end

    it 'should not accept invalid names' do
      subject.tags = '#hashtag'
      expect(subject).to be_invalid
      subject.tags = 'hash-tag'
      expect(subject).to be_invalid
    end

    it 'can contain spaces and underscores' do
      subject.tags = 'Firsttag secondtag'
      expect(subject).to be_valid
      subject.tags = 'First_tag'
      expect(subject).to be_valid
    end

    # it 'should not exept invalid tags' do
    #   subject.tags = '#hashtag'
    #   expect(subject).to be_invalid
    # end

    # it 'can contain spaces' do
    #   subject.name = Faker::Name.name_with_middle
    #   expect(subject).to be_valid
    # end
  end

  # describe 'Description' do
  #   it 'should be present' do
  #     subject.description = '   '
  #     expect(subject).to be_invalid
  #   end

  #   it 'should be wide' do
  #     subject.description = 'a' * 49
  #     expect(subject).to be_invalid
  #   end
  # end

  # describe 'User id' do
  #   it 'should be present' do
  #     subject.user_id = nil
  #     expect(subject).to be_invalid
  #   end

  #   it 'should exist and user should be present' do
  #     expect(subject.user_id).to be_equal User.last.id
  #   end
  # end
end
