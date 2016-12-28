
FactoryGirl.define do
  factory :issue do
    name        { Faker::Name.name_with_middle }
    address     { Faker::Address.street_address }
    phone       { Faker::PhoneNumber.cell_phone }
    email       { user.email }
    description { Faker::Lorem.characters(255) }
    attachment  do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'files', 'avatar.jpg')
      )
    end
    association :user, factory: :user
    association :category, factory: :category
  end

  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

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
