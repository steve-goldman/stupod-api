FactoryGirl.define do
  factory :playlist do
    association :user
    name { Faker::Name.name }
  end
end
