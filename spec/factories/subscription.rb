FactoryGirl.define do
  factory :subscription do
    association :playlist
    association :channel
  end
end
