require 'rails_helper'

RSpec.describe PlaylistElement, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:playlist_element)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :playlist_element }
    it { should validate_presence_of :playlist }
    it { should validate_presence_of :item }
    it { should validate_presence_of :position }
    it { should validate_numericality_of(:position).only_integer }
  end

  describe "associations" do
    it { should belong_to :playlist }
    it { should belong_to :item }
  end

end
