# frozen_string_literal: true
require 'rails_helper'

feature 'Sign in' do
  scenario 'User couldn`t sign in with incorrect email and pass', skip: true do
    login('not_our_user@example.com', 'password')
    expect(page).to have_content 'Invalid Email or password'
  end

  scenario 'Admin can sign in with email and password', skip: true do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    expect(page).to have_content 'Signed in successfully'
  end
end
