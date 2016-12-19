# frozen_string_literal: true

User.create!(email: 'test@test.com', password: 'password',
             role: :admin)

User.create!(email: 'user@test.com', password: 'password',
             role: :user)
