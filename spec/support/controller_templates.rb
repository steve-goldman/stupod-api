shared_context "an indexable resource" do
  context "when the request is not authenticated" do
    before { get index_path }
    it_behaves_like "an unauthenticated request"
  end

  context "when the request is authenticated" do
    before { get index_path, headers: headers }
    it_behaves_like "an index request"
  end
end

shared_context "an unauthenticated request" do
  it "has status code 401" do
    expect(response).to have_http_status(401)
  end
end

shared_context "an unprocessable request" do |message = "Validation failed"|
  it "has status code 422" do
    expect(response).to have_http_status(422)
  end

  it "returns a failure message" do
    expect(response.body).to match(/#{message}/)
  end
end

shared_context "a request for a missing resource" do |resource_name|
  it "has status code 404" do
    expect(response).to have_http_status(404)
  end

  it "returns a not found message" do
    expect(response.body).to match(/Couldn't find #{resource_name}/)
  end
end

shared_context "an index request" do
  it "returns a json array" do
    expect(json.is_a? Array).to be(true)
  end

  it "has status code 200" do
    expect(response).to have_http_status(200)
  end
end

shared_context "a show request" do
  it "returns the resource" do
    expect(json["id"]).to eq(resource.id)
  end

  it "has status code 200" do
    expect(response).to have_http_status(200)
  end
end

shared_context "a destroy request" do
  it "has status code 204" do
    expect(response).to have_http_status(204)
  end
end

shared_context "an update request" do
  it "returns status code 204" do
    expect(response).to have_http_status(204)
  end
end

shared_context "a create request" do
  it "has status code 201" do
    expect(response).to have_http_status(201)
  end
end
