FactoryGirl.define do
  factory :channel do
    url { Faker::Internet.url }
    title "This is My Title"
  end
end
