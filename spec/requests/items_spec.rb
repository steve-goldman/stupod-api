require "rails_helper"

RSpec.describe "Items API" do

  let!(:channel) { create(:channel) }
  let!(:items) { FactoryGirl.create_list(:item, 20, channel: channel) }
  let(:token) { Knock::AuthToken.new(payload: { sub: "user-token" }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /channels/:channel_id/items" do
    it "does not allow an unauthenticated request" do
      get channel_items_path(channel_id: channel.id)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when channel exists" do
        before { get channel_items_path(channel_id: channel.id), headers: headers }

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end

        it "returns all todo items" do
          expect(json.size).to eq(items.count)
        end
      end

      context "when channel does not exist" do
        before { get channel_items_path(channel_id: 999999), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a not found message" do
          expect(response.body).to match(/Couldn't find Channel/)
        end
      end
    end
  end

  describe "GET /channels/:channel_id/items/:id" do
    it "does not allow an unauthenticated request" do
      get channel_item_path(channel_id: channel.id, id: items.first.id)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when item exists" do
        before { get channel_item_path(channel_id: channel.id, id: items.first.id), headers: headers }

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end

        it "returns the item" do
          expect(json["id"]).to eq(items.first.id)
        end
      end

      context "when item does not exist" do
        before { get channel_item_path(channel_id: channel.id, id: 999999), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a not found message" do
          expect(response.body).to match(/Couldn't find Item/)
        end
      end
    end
  end
end
