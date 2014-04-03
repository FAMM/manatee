FactoryGirl.define do
  factory :budget do |f|
    name "Test Budget"
    description "This is a budget for test purposes"
    users {[FactoryGirl.create(:user)]}
  end
end
