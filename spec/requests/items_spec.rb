require "rails_helper"

RSpec.describe "Items API" do

  let!(:channel) { create(:channel) }
  let!(:items) { FactoryGirl.create_list(:item, 20, channel: channel) }

  describe "GET /channels/:channel_id/items" do
    context "when channel exists" do
      before { get "/channels/#{channel.id}/items" }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns all todo items" do
        expect(json.size).to eq(items.count)
      end
    end

    context "when channel does not exist" do
      before { get "/channels/999999/items" }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Channel/)
      end
    end
  end

  describe "GET /channels/:channel_id/items/:id" do
    context "when item exists" do
      before { get "/channels/#{channel.id}/items/#{items.first.id}" }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the item" do
        expect(json["id"]).to eq(items.first.id)
      end
    end

    context "when item does not exist" do
      before { get "/channels/#{channel.id}/items/999999" }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
  
end
