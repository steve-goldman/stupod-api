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
    context "when the request is not authenticated" do
      before { get playlist_path(playlists.first) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the record exists and belongs to the user" do
        let(:resource) { playlists.first }
        before { get playlist_path(resource), headers: headers }
        it_behaves_like "a show request"
      end

      context "when the record exists and belongs to another user" do
        before { get playlist_path(other_playlists.first), headers: headers }
        it_behaves_like "a request for a missing resource", "Playlist"
      end

      context "when the record does not exist" do
        before { get playlist_path(99999), headers: headers }
        it_behaves_like "a request for a missing resource", "Playlist"
      end
    end
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
    context "when the request is not authenticated" do
      before { delete playlist_path(playlists.first) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        let(:resource) { playlists.first }
        before { delete playlist_path(resource), headers: headers }
        it_behaves_like "a destroy request"
      end

      context "when the request is invalid" do
        before { delete playlist_path(other_playlists.first), headers: headers }
        it_behaves_like "a request for a missing resource", "Playlist"
      end
    end
  end
end
