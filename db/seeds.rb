# frozen_string_literal: true
User.where(email: 'admin@test.com').first_or_create(password: 'password',
                                                   role: :admin)
User.where(email: 'moderator@test.com').first_or_create(password: 'password',
                                                    role: :moderator)
User.where(email: 'reporter@test.com').first_or_create(password: 'password',
                                                   role: :reporter)
