# frozen_string_literal: true
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    email
    password 'passwordd'
  end
end
