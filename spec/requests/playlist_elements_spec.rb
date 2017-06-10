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
      it_behaves_like "a request for a missing resource"
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
    let(:newPosition) { 1 }
    let(:attributes) { { id: playlist_elements.first.id, position: newPosition } }

    context "when the request is not authenticated" do
      before { put playlist_playlist_element_path(playlist, playlist_elements.first), params: attributes }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the playlist exists" do
        context "when the playlist element exists" do
          before { put playlist_playlist_element_path(playlist, playlist_elements.first), params: attributes, headers: headers }
          it_behaves_like "an update request"
        end

        context "when the playlist element does not exist" do
          before { put playlist_playlist_element_path(playlist_id: playlist.id, id: 999999), params: attributes, headers: headers }
          it_behaves_like "a request for a missing resource", "PlaylistElement"
        end
      end

      context "when the playlist does not exist" do
        before { put playlist_playlist_element_path(playlist_id: 999999, id: playlist_elements.first.id), params: attributes, headers: headers }
        it_behaves_like "a request for a missing resource", "Playlist"
      end
    end
  end

  describe "DELETE /playlists/:playlist_id/playlist_elements/:id" do
    context "when the request is not authenticated" do
      before { delete playlist_playlist_element_path(playlist, playlist_elements.first) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        let(:resource) { playlist_elements.first }
        before { delete playlist_playlist_element_path(playlist, resource), headers: headers }
        it_behaves_like "a destroy request"
      end

      context "when the request is invalid" do
        before { delete playlist_playlist_element_path(other_playlist, playlist_elements.first), headers: headers }
        it_behaves_like "a request for a missing resource", "Playlist"
      end
    end
  end
end
