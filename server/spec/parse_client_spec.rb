require_relative 'spec_helper'

describe ParseClient do
  describe "#fetch_builds" do
    let(:client) { ParseClient.from_settings }
    context "when services are healthy" do
      it "should return builds" do
        builds = client.fetch_builds
        first = builds.first
        first["project"].acts_like? "string"
        first["url"].should =~ /\.com/
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should raise error" do
        expect {
          client.fetch_builds
        }.to raise_error ParseClient::Error
      end
    end
  end
end
