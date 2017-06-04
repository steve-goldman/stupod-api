require "rails_helper"

RSpec.describe "Playlists API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let(:other_user) { FactoryGirl.create :user, token_id: "other-user-token-id" }
  let!(:playlists) { FactoryGirl.create_list(:playlist, 10, user: user) }
  let!(:other_playlists) { FactoryGirl.create_list(:playlist, 10, user: other_user) }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /playlists" do
    it "does not allow an unauthenticated request" do
      get playlists_path
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      before { get playlists_path, headers: headers }

      it "returns playlists" do
        expect(json).to_not be_empty
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /playlists/:id" do
    it "does not allow an unauthenticated request" do
      get playlist_path(playlists.first.id)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the record exists and belongs to the user" do
        before { get playlist_path(playlists.first.id), headers: headers }

        it "returns the playlist" do
          expect(json).to_not be_empty
          expect(json["id"]).to eq(playlists.first.id)
        end

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end
      end

      context "when the record exists and belongs to another user" do
        before { get playlist_path(other_playlists.first.id), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a not found message" do
          expect(response.body).to match(/Couldn't find Playlist/)
        end
      end

      context "when the record does not exist" do
        before { get playlist_path(99999), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a not found message" do
          expect(response.body).to match(/Couldn't find Playlist/)
        end
      end
    end
  end

  describe "POST /playlists" do
    let(:name) { Faker::Name.name }
    let(:attributes) { { name: name } }

    it "does not allow an unauthenticated request" do
      post playlists_path, params: attributes
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { post playlists_path, params: attributes, headers: headers }

        it "creates a playlist" do
          expect(json["name"]).to eq(name)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the request is invalid" do
        before { post playlists_path, headers: headers } # missing params

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end

        it "returns a validation failure message" do
          expect(response.body).to match(/Validation failed/)
        end
      end
    end
  end

  describe "PUT /playlists/:id" do
    let(:name) { Faker::Name.name }
    let(:newName) { Faker::Name.name }
    let(:attributes) { { id: playlists.first.id, name: newName } }

    it "does not allow an unauthenticated request" do
      put playlist_path(playlists.first.id), params: attributes
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { put playlist_path(playlists.first.id), params: attributes, headers: headers }

        it "returns status code 204" do
          expect(response).to have_http_status(204)
        end
      end

      context "when the request is invalid" do
        let(:invalid_attributes) { { id: playlists.first.id, name: playlists.last.name } }
        before { put playlist_path(playlists.first.id), params: invalid_attributes, headers: headers }

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end

        it "returns a validation failure message" do
          expect(response.body).to match(/Validation failed/)
        end
      end
    end
  end

  describe "DELETE /playlists/:id" do
    it "does not allow an unauthenticated request" do
      delete playlist_path(playlists.first.id)
      assert_response :unauthorized
    end

    context "when the request is authenticated" do
      context "when the request is valid" do
        before { delete playlist_path(playlists.first.id), headers: headers }

        it "returns status code 204" do
          expect(response).to have_http_status(204)
        end
      end

      context "when the request is invalid" do
        before { delete playlist_path(other_playlists.first.id), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
