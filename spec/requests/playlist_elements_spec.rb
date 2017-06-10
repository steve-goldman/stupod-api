require "rails_helper"

RSpec.describe "PlaylistElementss API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let!(:playlist) { FactoryGirl.create :playlist, user: user }
  let!(:other_playlist) { FactoryGirl.create :playlist, user: user }
  let!(:playlist_elements) { FactoryGirl.create_list(:playlist_element, 10, playlist: playlist) }
  let!(:other_playlist_elements) { FactoryGirl.create_list(:playlist_element, 10, playlist: other_playlist) }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /playlists/:playlist_id/playlist_elements" do
    context "when the playlist exists" do
      let(:index_path) { playlist_playlist_elements_path(playlist) }
      it_behaves_like "an indexable resource"
    end

    context "when the playlist does not exist" do
      before { get playlist_playlist_elements_path(playlist_id: 999999), headers: headers }
      it_behaves_like "a request for a missing resource", "Playlist"
    end
  end

  describe "POST /playlists/:playlist_id/playlist_elements" do
    let(:position) { 0 }
    let(:item) { playlist_elements.first.item }
    let(:attributes) { { item_id: item.id,
                         position: position } }

    context "when the request is not authenticated" do
      before { post playlist_playlist_elements_path(playlist), params: attributes }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { post playlist_playlist_elements_path(playlist), params: attributes, headers: headers }
        it_behaves_like "a create request"
      end

      context "when the request is invalid" do
        before { post playlist_playlist_elements_path(playlist), headers: headers } # missing params
        it_behaves_like "an unprocessable request"
      end
    end
  end

  describe "PUT /playlists/:playlist_id/playlist_elements/:id" do
    let(:resource) { playlist_elements.first }
    let(:new_position) { 1 }
    let(:attributes) { { id: resource.id, position: new_position } }
    let(:invalid_attributes) { { id: resource.id, position: "invalid-position" } }

    context "when the playlist exists" do
      let(:update_path) { playlist_playlist_element_path playlist, resource }
      let(:invalid_update_path) { playlist_playlist_element_path playlist_id: playlist.id, id: 999999 }
      it_behaves_like "an updatable resource"
    end

    context "when the playlist does not exist" do
      before { put playlist_playlist_element_path(playlist_id: 999999, id: resource.id), params: attributes, headers: headers }
      it_behaves_like "a request for a missing resource", "Playlist"
    end
  end

  describe "DELETE /playlists/:playlist_id/playlist_elements/:id" do
    let(:resource) { playlist_elements.first }

    context "when the playlist exists" do
      let(:destroy_path) { playlist_playlist_element_path playlist, resource }
      let(:invalid_destroy_path) { playlist_playlist_element_path playlist_id: playlist.id, id: 999999 }
      it_behaves_like "a destroyable resource", "PlaylistElement"
    end

    context "when the playlist does not exist" do
      before { delete playlist_playlist_element_path(playlist_id: 999999, id: resource.id), headers: headers }
      it_behaves_like "a request for a missing resource", "Playlist"
    end
  end
end
