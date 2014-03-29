# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    language "de"
    email {Faker::Internet.email}
    password "testtest"
    password_confirmation "testtest"
  end
end
