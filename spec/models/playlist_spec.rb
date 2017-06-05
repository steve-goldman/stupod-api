require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:playlist)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :playlist }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { should validate_presence_of :user }
    it { should validate_presence_of :name }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should have_many(:playlist_elements).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end
end
