require "rails_helper"

RSpec.describe "Channels API", type: :request do

  let!(:channels) { FactoryGirl.create_list(:channel, 10) }

  describe "GET /channels" do
    before { get "/channels" }

    it "returns channels" do
      expect(json).to_not be_empty
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /channels/:id" do
    context "when the record exists" do
      before { get "/channels/#{channels.first.id}" }

      it "returns the channel" do
        expect(json).to_not be_empty
        expect(json["id"]).to eq(channels.first.id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "when the record does not exist" do
      before { get "/channels/99999" }
      
      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Channel/)
      end
    end
  end
  
end
