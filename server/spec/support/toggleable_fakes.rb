unless ENV["INTEGRATION"] == "true"
  stub_request(:get, "api.parse.com").to_rack(FakeParse)
end
