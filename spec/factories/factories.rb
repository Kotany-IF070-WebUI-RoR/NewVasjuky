FactoryGirl.define do
  factory :issue do
    name        { Faker::Name.name_with_middle }
    address     { Faker::Address.street_address }
    phone       { Faker::PhoneNumber.cell_phone }
    email       { Faker::Internet.email }
    title       { Faker::Lorem.characters(30) }
    description { Faker::Lorem.characters(255) }
    location    { Faker::Address.street_address }
<<<<<<< 6481111ca59c341e51675d976271dab8e2ade256
    association :user, factory: :user
    association :category, factory: :category
  end

  factory :issue_attachment do
=======
    status :pending
>>>>>>> Adds form for editing issue. Adds issue statuses
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
    image_url   { Faker::Avatar.image }
    role        :reporter

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

  factory :comment do
    title { Faker::Lorem.sentence(4) }
    content { Faker::Lorem.sentence(10) }
    association :commentable, factory: :issue
    association :user, factory: :user
  end
end
