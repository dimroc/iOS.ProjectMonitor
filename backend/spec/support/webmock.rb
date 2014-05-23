require 'webmock/rspec'

module FakeSpecHelpers
  def servers_return_healthy
    puts "WARNING: Stubbing out healthy servers in an integration run" if ENV["INTEGRATION"] == "true"
    WebMock.stub_request(:any, /.*api.parse.com\/.*/).to_rack(FakeParse)
    WebMock.stub_request(:any, /.*semaphoreapp.com\/.*/).to_rack(FakeSemaphore)
    WebMock.stub_request(:any, /.*api.pusherapp.com\/.*/).to_rack(FakePusher)
  end

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
    FakeParse.reset

    if ENV["INTEGRATION"] == "true"
      WebMock.allow_net_connect!
      client = ParseClient.from_settings
      client.fetch_all_builds.each do |build|
        client.delete_build(build)
      end
    else
      WebMock.disable_net_connect!
      servers_return_healthy
    end
  end
end
