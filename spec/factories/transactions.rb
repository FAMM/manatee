FactoryGirl.define do
  factory :transaction do |f|
    amount "12.42"
    date {Date.today}
  end
end
