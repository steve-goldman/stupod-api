require "rails_helper"

RSpec.describe "Channels API", type: :request do

  let!(:channels) { FactoryGirl.create_list(:channel, 10) }
  let(:token) { Knock::AuthToken.new(payload: { sub: "user-token" }).token }
  let(:headers) { { authorization: "Bearer #{token}" } }

  describe "POST /create" do
    let(:existing_url) { channels.first.url }
    let(:new_url) { "http://path/to/feed.xml" }
    let(:not_loadable_url) { "http://bad/url" }
    let(:attributes_exists) { { url: existing_url } }
    let(:attributes_new) { { url: new_url } }
    let(:attributes_not_loadable) { { url: not_loadable_url } }

    context "when the request is not authenticated" do
      before { post channels_path, params: attributes_exists }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the channel exists" do
        before { post channels_path, params: attributes_exists, headers: headers }

        it "returns a channel" do
          expect(json["url"]).to eq(existing_url)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the channel is new" do
        before { allow_any_instance_of(ChannelLoader)
                 .to receive(:load).and_return(FactoryGirl.build(:channel, url: new_url)) }
        before { post channels_path, params: attributes_new, headers: headers }

        it "returns a channel" do
          expect(json["url"]).to eq(new_url)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the channel is not loadable" do
        before { allow_any_instance_of(ChannelLoader).to receive(:load).and_raise }
        before { post channels_path, params: attributes_not_loadable, headers: headers }

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe "GET /channels" do
    context "when the request is not authenticated" do
      before { get channels_path }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      before { get channels_path, headers: headers }
      it_behaves_like "an index request"
    end
  end

  describe "GET /channels/:id" do
    context "when the request is not authenticated" do
      before { get channel_path(channels.first) }
      it_behaves_like "an unauthenticated request"
    end

    context "when the request is authenticated" do
      context "when the record exists" do
        before { get channel_path(channels.first), headers: headers }

        it "returns the channel" do
          expect(json).to_not be_empty
          expect(json["id"]).to eq(channels.first.id)
        end

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end
      end

      context "when the record does not exist" do
        before { get channel_path(id: 99999), headers: headers }

        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end

        it "returns a not found message" do
          expect(response.body).to match(/Couldn't find Channel/)
        end
      end
    end
  end
end
