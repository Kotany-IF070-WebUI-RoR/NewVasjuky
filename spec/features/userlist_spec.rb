# frozen_string_literal: true
require 'rails_helper'

feature 'List of users' do
  scenario 'Admin can browse list of users' do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    visit account_users_path
    expect(page).to have_content user.email
  end

  scenario 'Moderator can browse list of users' do
    user = create(:user, role: :moderator)
    login(user.email, user.password)
    visit account_users_path
    expect(page).to have_content user.email
  end

  scenario 'Reporter can not browse list of users', skip: true do
    user = create(:user, role: :reporter)
    login(user.email, user.password)
    visit account_users_path
    expect(page).to have_content 'Access denied'
  end

  scenario 'User list has pagination' do
    user = create(:user, role: :admin)
    create_list(:user, 50)
    login(user.email, user.password)
    visit account_users_path
    expect(page).to have_selector 'a[rel="next"]'
    first('a[rel="next"]').click
    expect(page).to have_content '@'
  end
end

feature 'Banning users', skip: true do
  scenario 'Moderator can ban/unban users' do
    moderator = create(:user, role: :moderator,
                              banned: false)
    reporter = create(:user, role: :reporter,
                             banned: false)
    login(moderator.email, moderator.password)
    visit account_users_path
    expect(page).to have_content 'Ban'
    click_link 'Ban'
    reporter.reload
    expect(page).to have_content 'Unban'
    expect(reporter.banned?).to be true
    click_link 'Unban'
    reporter.reload
    expect(page).to have_content 'Ban'
    expect(reporter.banned?).to be false
  end
end
