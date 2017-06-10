require "rails_helper"

RSpec.describe "Subscriptions API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let!(:playlist) { FactoryGirl.create :playlist, user: user }
  let!(:channel) { FactoryGirl.create :channel }
  let!(:subscription) { FactoryGirl.create :subscription, playlist: playlist, channel: channel }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /subscriptions" do
    context "when the request is not authenticated" do
      before { get subscriptions_path }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      before { get subscriptions_path, headers: headers }
      it_behaves_like "an index request"
    end
  end

  describe "POST /subscriptions" do
    let!(:newChannel) { FactoryGirl.create :channel }
    let(:attributes) { { channel_id: newChannel.id, playlist_id: playlist.id } }

    context "when the request is not authenticated" do
      before { post subscriptions_path, params: attributes }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { post subscriptions_path, params: attributes, headers: headers }

        it "creates a subscription" do
          expect(json["channel_id"]).to eq(newChannel.id)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the request is invalid" do
        before { post subscriptions_path, headers: headers } # missing params

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a validation failure message" do
          expect(response.body).to match(/Couldn't find Playlist/)
        end
      end
    end
  end

  describe "PUT /subscriptions/:id" do
    let!(:newPlaylist) { FactoryGirl.create :playlist, user: user }
    let(:attributes) { { id: subscription.id, playlist_id: newPlaylist.id } }

    context "when the request is not authenticated" do
      before { put subscription_path(subscription), params: attributes }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { put subscription_path(subscription), params: attributes, headers: headers }

        it "returns status code 204" do
          expect(response).to have_http_status(204)
        end
      end

      context "when the request is invalid" do
        let(:invalid_attributes) { { id: subscription.id, playlist_id: "unknown-playlist" } }
        before { put subscription_path(subscription), params: invalid_attributes, headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a validation failure message" do
          expect(response.body).to match(/Couldn't find Playlist/)
        end
      end
    end
  end

  describe "DELETE /subscriptions/:id" do
    context "when the request is not authenticated" do
      before { delete subscription_path(subscription) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        let(:resource) { subscription }
        before { delete subscription_path(resource), headers: headers }
        it_behaves_like "a destroy request"
      end

      context "when the request is invalid" do
        before { delete subscription_path("unknown-subscription"), headers: headers }
        it_behaves_like "a request for a missing resource", "Subscription"
      end
    end
  end
end
