require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :user }
    it { should validate_presence_of :token_id }
    it { should validate_uniqueness_of :token_id }
  end

  describe "associations" do
    it { should have_many(:playlists).dependent(:destroy) }
  end
end
