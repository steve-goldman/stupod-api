FactoryGirl.define do
  factory :playlist_element do
    association :playlist
    association :item
    position 0
  end
end
