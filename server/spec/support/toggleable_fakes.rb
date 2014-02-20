unless ENV["INTEGRATION"] == "true"
  stub_request(:any, "api.parse.com").to_rack(FakeParse)
  stub_request(:any, "semaphoreapp.com").to_rack(FakeSemaphore)
end
