require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:subscription)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :subscription }
    it { should validate_presence_of :playlist }
    it { should validate_presence_of :channel }
    it { should validate_uniqueness_of(:channel).scoped_to(:playlist_id) }
  end

  describe "associations" do
    it { should belong_to :playlist }
    it { should belong_to :channel }
  end

end
