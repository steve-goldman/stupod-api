require "rails_helper"

RSpec.describe "Items API" do

  let!(:channel) { create(:channel) }
  let!(:items) { FactoryGirl.create_list(:item, 20, channel: channel) }
  let(:token) { Knock::AuthToken.new(payload: { sub: "user-token" }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /channels/:channel_id/items" do
    context "when the channel exists" do
      let(:index_path) { channel_items_path(channel) }
      it_behaves_like "an indexable resource"
    end

    context "when channel does not exist" do
      before { get channel_items_path(channel_id: 999999), headers: headers }
      it_behaves_like "a request for a missing resource", "Channel"
    end
  end

  describe "GET /channels/:channel_id/items/:id" do
    let(:resource) { items.first }
    let(:show_path) { channel_item_path channel, resource }
    let(:invalid_show_path) { channel_item_path channel_id: channel.id, id: 999999 }

    context "when the channel exists" do
      it_behaves_like "a showable resource", "Item"
    end

    context "when the channel does not exist" do
      before { get channel_item_path(channel_id: 999999, id: resource.id), headers: headers }
      it_behaves_like "a request for a missing resource", "Channel"
    end
  end
end
