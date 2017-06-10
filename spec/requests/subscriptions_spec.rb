require "rails_helper"

RSpec.describe "Subscriptions API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let!(:playlist) { FactoryGirl.create :playlist, user: user }
  let!(:channel) { FactoryGirl.create :channel }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /subscriptions" do
    let!(:subscriptions) { FactoryGirl.create_list :subscription, 2, playlist: playlist }
    let(:index_path) { subscriptions_path }
    it_behaves_like "an indexable resource"
  end

  describe "POST /subscriptions" do
    let(:create_path) { subscriptions_path }
    let(:new_channel) { FactoryGirl.create :channel }
    let(:attributes) { { channel_id: new_channel.id, playlist_id: playlist.id } }

    context "when the playlist exists" do
      it_behaves_like "a createable resource", true
    end

    context "when the playlist does not exist" do
      before { post create_path, params: { channel_id: new_channel.id, playlist_id: 999999 }, headers: headers }
      it_behaves_like "a request for a missing resource", "Playlist"
    end
  end

  describe "PUT /subscriptions/:id" do
    let(:resource) { FactoryGirl.create :subscription, playlist: playlist, channel: channel }
    let(:new_playlist) { FactoryGirl.create :playlist, user: user }
    let(:attributes) { { id: resource.id, playlist_id: new_playlist.id } }
    let(:update_path) { subscription_path resource }
    let(:invalid_update_path) { subscription_path id: 999999 }

    context "when the playlist exists" do
      it_behaves_like "an updatable resource", "Subscription", true
    end

    context "when the playlist does not exist" do
      before { put update_path, params: { id: resource.id, playlist_id: 999999 }, headers: headers }
      it_behaves_like "a request for a missing resource", "Playlist"
    end
  end

  describe "DELETE /subscriptions/:id" do
    let(:resource) { FactoryGirl.create :subscription, playlist: playlist, channel: channel }
    let(:destroy_path) { subscription_path resource }
    let(:invalid_destroy_path) { subscription_path id: 999999 }
    it_behaves_like "a destroyable resource", "Subscription"
  end
end
