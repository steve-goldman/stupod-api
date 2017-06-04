FactoryGirl.define do
  factory :user do
    token_id { Faker::Name.name }
    password { Faker::Crypto.md5 }
  end
end
