require "rails_helper"

RSpec.describe "Subscriptions API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let!(:playlist) { FactoryGirl.create :playlist, user: user }
  let!(:channel) { FactoryGirl.create :channel }
  let!(:subscription) { FactoryGirl.create :subscription, playlist: playlist, channel: channel }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /subscriptions" do
    let(:index_path) { subscriptions_path }
    it_behaves_like "an indexable resource"
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
        it_behaves_like "a create request"
      end

      context "when the playlist does not exist" do
        before { post subscriptions_path, headers: headers } # missing params
        it_behaves_like "a request for a missing resource", "Playlist"
      end
    end
  end

  describe "PUT /subscriptions/:id" do
    let(:resource) { subscription }
    let!(:new_playlist) { FactoryGirl.create :playlist, user: user }
    let(:attributes) { { id: resource.id, playlist_id: new_playlist.id } }
    let(:update_path) { subscription_path resource }
    let(:invalid_update_path) { subscription_path id: 999999 }
    it_behaves_like "an updatable resource", "Subscription", true
  end

  describe "DELETE /subscriptions/:id" do
    let(:resource) { subscription }
    let(:destroy_path) { subscription_path resource }
    let(:invalid_destroy_path) { subscription_path id: 999999 }
    it_behaves_like "a destroyable resource", "Subscription"
  end
end
