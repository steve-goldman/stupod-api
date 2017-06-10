require "rails_helper"

RSpec.describe "Playlists API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let(:other_user) { FactoryGirl.create :user, token_id: "other-user-token-id" }
  let!(:playlists) { FactoryGirl.create_list(:playlist, 10, user: user) }
  let!(:other_playlists) { FactoryGirl.create_list(:playlist, 10, user: other_user) }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /playlists" do
    let(:index_path) { playlists_path }
    it_behaves_like "an indexable resource"
  end

  describe "GET /playlists/:id" do
    let(:resource) { playlists.first }
    let(:show_path) { playlist_path resource }
    let(:invalid_show_path) { playlist_path id: 999999 }
    it_behaves_like "a showable resource", "Playlist"
  end

  describe "POST /playlists" do
    let(:name) { Faker::Name.name }
    let(:attributes) { { name: name } }

    context "when the request is not authenticated" do
      before { post playlists_path, params: attributes }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { post playlists_path, params: attributes, headers: headers }
        it_behaves_like "a create request"
      end

      context "when the request is invalid" do
        before { post playlists_path, headers: headers } # missing params
        it_behaves_like "an unprocessable request"
      end
    end
  end

  describe "PUT /playlists/:id" do
    let(:name) { Faker::Name.name }
    let(:newName) { Faker::Name.name }
    let(:attributes) { { id: playlists.first.id, name: newName } }

    context "when the request is not authenticated" do
      before { put playlist_path(playlists.first), params: attributes}
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { put playlist_path(playlists.first), params: attributes, headers: headers }
        it_behaves_like "an update request"
      end

      context "when the request is invalid" do
        let(:invalid_attributes) { { id: playlists.first.id, name: playlists.last.name } }
        before { put playlist_path(playlists.first), params: invalid_attributes, headers: headers }
        it_behaves_like "an unprocessable request"
      end
    end
  end

  describe "DELETE /playlists/:id" do
    let(:resource) { playlists.first }
    let(:destroy_path) { playlist_path resource }
    let(:invalid_destroy_path) { playlist_path id: 999999 }
    it_behaves_like "a destroyable resource", "Playlist"
  end
end
