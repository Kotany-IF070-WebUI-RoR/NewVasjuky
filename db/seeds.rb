# frozen_string_literal: true
User.where(email: 'test@test.com').first_or_create(password: 'password',
                                                   role: :admin)
User.where(email: 'user@test.com').first_or_create(password: 'password',
                                                   role: :user)
