FactoryGirl.define do
  factory :item do
    association :channel
    guid { Faker::Crypto.sha1 }
    url { Faker::Internet.url }
    title "The Tile of the Item"
  end
end

