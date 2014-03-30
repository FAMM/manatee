FactoryGirl.define do
  factory :category do |f|
    name {Faker::Commerce.department}
    planned 420.12
  end
end
