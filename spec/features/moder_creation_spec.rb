# frozen_string_literal: true
require 'rails_helper'

feature 'Moder creation and delete' do
  let(:before_user_count) { User.count }
  let(:pass) { Faker::Internet.password }
  let(:email) { Faker::Internet.email }

  scenario 'Admin can create moderators' do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    visit new_account_user_path
    fill_in 'Email', with: :email
    fill_in 'Password', with: :pass, match: :prefer_exact
    fill_in 'Password confirmation', with: :pass, match: :prefer_exact
    click_on 'Create User'
    expect(page).to have_content :email
    expect(page).to have_current_path(account_users_path)
    expect(User.count).to_not eq :before_user_count
  end

  scenario 'Admin can delete moderators' do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    moder = create(:user, role: :moderator)
    visit account_users_path
    expect(page).to have_content moder.email
    find_link('delete').click
    expect(User.count).to_not eq :before_user_count
    visit account_users_path
    expect(page).to_not have_content moder.email
  end
end
