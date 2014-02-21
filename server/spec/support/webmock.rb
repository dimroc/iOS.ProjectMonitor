require 'webmock/rspec'

module FakeSpecHelpers
  def servers_return_error
    WebMock.stub_request(:any, /.*/).to_rack(FakeError)
  end

  def servers_return_unauthorized
    WebMock.stub_request(:any, /.*/).to_rack(FakeUnauthorized)
  end
end

RSpec.configure do |config|
  config.include FakeSpecHelpers

  config.before(:each) do
    if ENV["INTEGRATION"] == "true"
      WebMock.allow_net_connect!
    else
      WebMock.disable_net_connect!
      WebMock.stub_request(:any, /.*api.parse.com\/.*/).to_rack(FakeParse)
      WebMock.stub_request(:any, /.*semaphoreapp.com\/.*/).to_rack(FakeSemaphore)
    end
  end
end
