FactoryGirl.define do
  factory :playlist do
    user { Faker::Name.name }
    name { Faker::Name.name }
  end
end
