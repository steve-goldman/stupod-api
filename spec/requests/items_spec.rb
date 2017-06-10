require "rails_helper"

RSpec.describe "Items API" do

  let!(:channel) { create(:channel) }
  let!(:items) { FactoryGirl.create_list(:item, 20, channel: channel) }
  let(:token) { Knock::AuthToken.new(payload: { sub: "user-token" }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /channels/:channel_id/items" do
    context "when the request is not authenticated" do
      before { get channel_items_path(channel) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when channel exists" do
        before { get channel_items_path(channel), headers: headers }
        it_behaves_like "an index request"
      end

      context "when channel does not exist" do
        before { get channel_items_path(channel_id: 999999), headers: headers }
        it_behaves_like "a request for a missing resource", "Channel"
      end
    end
  end

  describe "GET /channels/:channel_id/items/:id" do
    context "when the request is not authenticated" do
      before { get channel_item_path(channel, items.first) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when item exists" do
        let(:resource) { items.first }
        before { get channel_item_path(channel, resource), headers: headers }
        it_behaves_like "a show request"
      end

      context "when item does not exist" do
        before { get channel_item_path(channel, 999999), headers: headers }
        it_behaves_like "a request for a missing resource", "Item"
      end
    end
  end
end
