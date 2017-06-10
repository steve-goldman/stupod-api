require "rails_helper"

RSpec.describe "Channels API", type: :request do

  let(:token) { Knock::AuthToken.new(payload: { sub: "user-token" }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "POST /create" do
    let(:create_path) { channels_path }
    let(:attributes) { { url: Faker::Internet.url } }

    context "when the channel does not exist" do
      let(:channel) { FactoryGirl.build :channel }
      before { allow_any_instance_of(ChannelLoader).to receive(:load).and_return(channel) }
      it_behaves_like "a createable resource", true
    end

    context "when the channel exists" do
      let(:channel) { FactoryGirl.create :channel }
      let(:attributes_exists) { { url: channel.url } }
      before { post channels_path, params: attributes_exists, headers: headers }
      it_behaves_like "a create request"
    end

    context "when the channel is not loadable" do
      before { allow_any_instance_of(ChannelLoader).to receive(:load).and_raise }
      before { post channels_path, params: attributes, headers: headers }
      it_behaves_like "an unprocessable request", "Unable to load channel"
    end
  end

  describe "GET /channels" do
    let!(:channels) { FactoryGirl.create_list :channel, 2 }
    let(:index_path) { channels_path }
    it_behaves_like "an indexable resource"
  end

  describe "GET /channels/:id" do
    let(:resource) { FactoryGirl.create :channel }
    let(:show_path) { channel_path resource }
    let(:invalid_show_path) { channel_path id: 999999 }
    it_behaves_like "a showable resource", "Channel"
  end
end
