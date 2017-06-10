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

shared_context "a showable resource" do |resourceName|
  context "when the request is not authenticated" do
    before { get show_path }
    it_behaves_like "an unauthenticated request"
  end

  context "when the request is authenticated" do
    context "when the resource exists" do
      before { get show_path, headers: headers }
      it_behaves_like "a show request"
    end

    context "when the record does not exist" do
      before { get invalid_show_path, headers: headers }
      it_behaves_like "a request for a missing resource", resourceName
    end
  end
end

shared_context "a destroyable resource" do |resourceName|
  context "when the request is not authenticated" do
    before { delete destroy_path }
    it_behaves_like "an unauthenticated request"
  end

  context "when the request is authenticated" do
    context "when the resource exists" do
      before { delete destroy_path, headers: headers }
      it_behaves_like "a destroy request"
    end

    context "when the resource does not exist" do
      before { delete invalid_destroy_path, headers: headers }
      it_behaves_like "a request for a missing resource", resourceName
    end
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
