require "rails_helper.rb"

RSpec.describe Channel, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:channel)).to be_valid
  end
    
  describe "validations" do
    subject { FactoryGirl.build :channel }
    it { should validate_uniqueness_of :url }
    it { should validate_presence_of :url }
    it { should validate_presence_of :title }
  end

  describe "associations" do
    it { should have_many(:items).dependent(:destroy) }
  end
  
end
