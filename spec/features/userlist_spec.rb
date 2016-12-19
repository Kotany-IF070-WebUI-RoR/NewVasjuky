# frozen_string_literal: true
require 'rails_helper'

feature 'List of users' do
  scenario 'Admin can browse list of users' do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    visit account_users_path
    expect(page).to have_content user.email
  end

  scenario 'User can not browse list of users' do
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
    expect(page).to have_content '@example.com'
  end
end
