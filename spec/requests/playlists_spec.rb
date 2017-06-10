require "rails_helper"

RSpec.describe "Playlists API", type: :request do

  let(:user) { FactoryGirl.create :user, token_id: "user-token-id" }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.token_id }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "GET /playlists" do
    let!(:playlists) { FactoryGirl.create_list :playlist, 2, user: user }
    let(:index_path) { playlists_path }
    it_behaves_like "an indexable resource"
  end

  describe "GET /playlists/:id" do
    let(:resource) { FactoryGirl.create :playlist, user: user }
    let(:show_path) { playlist_path resource }
    let(:invalid_show_path) { playlist_path id: 999999 }
    it_behaves_like "a showable resource", "Playlist"
  end

  describe "POST /playlists" do
    let(:create_path) { playlists_path }
    let(:attributes) { { name: Faker::Name.name } }
    it_behaves_like "a createable resource"
  end

  describe "PUT /playlists/:id" do
    let(:resource) { FactoryGirl.create :playlist, user: user }
    let(:attributes) { { id: resource.id, name: Faker::Name.name } }
    let(:invalid_attributes) { { id: resource.id, name: "" } }
    let(:update_path) { playlist_path resource }
    let(:invalid_update_path) { playlist_path id: 999999 }
    it_behaves_like "an updatable resource"
  end

  describe "DELETE /playlists/:id" do
    let(:resource) { FactoryGirl.create :playlist, user: user }
    let(:destroy_path) { playlist_path resource }
    let(:invalid_destroy_path) { playlist_path id: 999999 }
    it_behaves_like "a destroyable resource", "Playlist"
  end
end
