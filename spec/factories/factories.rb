
FactoryGirl.define do
  factory :issue do
    name        { Faker::Name.name_with_middle }
    address     { Faker::Address.street_address }
    phone       { Faker::PhoneNumber.cell_phone }
    email       { Faker::Internet.email }
    category    { Faker::Lorem.words(4).join }
    description { Faker::Lorem.characters(255) }
    attachment  do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'files', 'avatar.jpg')
      )
    end
    association :user, factory: :user
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

  sequence :email do |n|
    "person#{n}@example.com"
  end
end
