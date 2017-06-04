require 'rails_helper'

RSpec.describe PlaylistElement, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:playlist_element)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :playlist_element }
    it { should validate_presence_of :playlist_id }
    it { should validate_presence_of :item_id }
    it { should belong_to :playlist }
    it { should belong_to :item }
  end

end
