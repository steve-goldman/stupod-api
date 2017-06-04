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
    it "does not allow an unauthenticated request" do
      get playlist_playlist_elements_path(playlist)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      before { get playlist_playlist_elements_path(playlist), headers: headers }

      it "returns playlists" do
        expect(json).to_not be_empty
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /playlists/:playlist_id/playlist_elements" do
    let(:position) { 0 }
    let(:item) { playlist_elements.first.item }
    let(:attributes) { { item_id: item.id,
                         position: position } }

    it "does not allow an unauthenticated request" do
      post playlist_playlist_elements_path(playlist), params: attributes
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { post playlist_playlist_elements_path(playlist), params: attributes, headers: headers }

        it "creates a playlist element" do
          expect(json["position"]).to eq(position)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the request is invalid" do
        before { post playlist_playlist_elements_path(playlist), headers: headers } # missing params

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end

        it "returns a validation failure message" do
          expect(response.body).to match(/Validation failed/)
        end
      end
    end
  end

  describe "PUT /playlists/:playlist_id/playlist_elements/:id" do
    let(:newPosition) { 1 }
    let(:attributes) { { id: playlist_elements.first.id, position: newPosition } }

    it "does not allow an unauthenticated request" do
      put playlist_playlist_element_path(playlist, playlist_elements.first.id), params: attributes
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { put playlist_playlist_element_path(playlist, playlist_elements.first.id), params: attributes, headers: headers }

        it "returns status code 204" do
          expect(response).to have_http_status(204)
        end
      end
    end
  end

  describe "DELETE /playlists/:playlist_id/playlist_elements/:id" do
    it "does not allow an unauthenticated request" do
      delete playlist_playlist_element_path(playlist, playlist_elements.first.id)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { delete playlist_playlist_element_path(playlist, playlist_elements.first.id), headers: headers }

        it "returns status code 204" do
          expect(response).to have_http_status(204)
        end
      end

      context "when the request is invalid" do
        before { delete playlist_playlist_element_path(other_playlist, playlist_elements.first.id), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
