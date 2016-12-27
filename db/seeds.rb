# frozen_string_literal: true
User.where(email: 'admin@test.com').first_or_create(name: 'Administrator',
                                                    password: 'password',
                                                    role: :admin,
                                                    banned: false)
User.where(email: 'moder@test.com').first_or_create(name: 'Moderator',
                                                    password: 'password',
                                                    role: :moderator,
                                                    banned: false)
User.where(email: 'repo1@test.com').first_or_create(name: 'Good Reporter',
                                                    password: 'password',
                                                    role: :reporter,
                                                    banned: false)
User.where(email: 'repo2@test.com').first_or_create(name: 'Bad Reporter',
                                                    password: 'password',
                                                    role: :reporter,
                                                    banned: true)
