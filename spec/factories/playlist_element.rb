FactoryGirl.define do
  factory :playlist_element do
    association :playlist
    association :item
  end
end
