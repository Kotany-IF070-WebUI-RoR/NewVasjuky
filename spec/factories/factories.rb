
FactoryGirl.define do
  factory :issue do
    name        { Faker::Name.name_with_middle }
    address     { Faker::Address.street_address }
    phone       { Faker::PhoneNumber.cell_phone }
    email       { Faker::Internet.email }
    category    { Faker::Lorem.words(4).join }
    description { Faker::Lorem.characters(255) }
    attachment  { Faker::File.file_name('path/to/') }
  end

  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end
end
