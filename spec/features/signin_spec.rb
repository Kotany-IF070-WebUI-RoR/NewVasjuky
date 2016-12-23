# frozen_string_literal: true
require 'rails_helper'

feature 'Sign in' do
  scenario 'User could not sign in with incorrect email and password' do
    login('not_our_user@example.com', 'password')
    expect(page).to have_content 'Invalid Email or password'
  end

  scenario 'Admin can sign in with email and password' do
    user = create(:user, role: :admin)
    login(user.email, user.password)
    expect(page).to have_content 'Signed in successfully'
  end
end
