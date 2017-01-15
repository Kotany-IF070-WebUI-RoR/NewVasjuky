FactoryGirl.define do
  factory :issue do
    name        { Faker::Name.name_with_middle }
    address     { Faker::Address.street_address }
    phone       { Faker::PhoneNumber.cell_phone }
    email       { Faker::Internet.email }
    title       { Faker::Lorem.characters(30) }
    description { Faker::Lorem.characters(255) }
    location    { Faker::Address.street_address }
    association :user, factory: :user
    association :category, factory: :category
  end

  factory :issue_attachment do
    attachment do
      [ Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'files', 'avatar.jpg')
      )
    ]
    end
  end

  factory :user do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    { Faker::Internet.password }

    trait :reporter do
      role :reporter
    end

    trait :admin do
      role :admin
    end

    trait :moderator do
      role :moderator
    end
  end

  factory :category do
    name { Faker::Name.title }
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end
end
