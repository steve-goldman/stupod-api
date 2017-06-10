shared_context "an unauthenticated request" do
  it "returns 401" do
    expect(response).to have_http_status(401)
  end
end

shared_context "a request for a missing resource" do |resource|
  it "returns status code 404" do
    expect(response).to have_http_status(404)
  end

  it "returns a not found message" do
    expect(response.body).to match(/Couldn't find #{resource}/)
  end
end

shared_context "an index request" do
  it "returns a json array" do
    expect(json.is_a? Array).to be(true)
  end

  it "returns 200" do
    expect(response).to have_http_status(200)
  end
end
