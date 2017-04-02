require "rails_helper.rb"

RSpec.describe Item, type: :model do

  it "has a valid factory" do
    expect(FactoryGirl.build(:item)).to be_valid
  end

  describe "validations" do
    subject { FactoryGirl.build :item }
    it { should validate_uniqueness_of :guid }
    it { should validate_presence_of :channel }
    it { should validate_presence_of :guid }
    it { should validate_presence_of :url }
    it { should validate_presence_of :title }
  end
  
  describe "associations" do
    it { should belong_to(:channel) }
  end

end
