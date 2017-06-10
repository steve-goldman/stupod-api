shared_context "an unauthenticated request" do
  it "returns 401" do
    expect(response).to have_http_status(401)
  end
end
