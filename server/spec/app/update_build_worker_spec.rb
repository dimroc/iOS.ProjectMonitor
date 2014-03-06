require 'spec_helper'

describe UpdateBuildWorker do
  describe "#perform" do
    let(:build) { new_parse_build }

    context "when services are healthy" do
      # unable to create a semaphore test server with expected builds
      # so force fakes here
      before { servers_return_healthy }
      let(:client) { ParseClient.from_settings }

      it "should update the build" do
        client.fetch_builds.should be_empty
        created_build = client.create(build)
        UpdateBuildWorker.new.perform(created_build)
        client.fetch_builds.count.should == 1
      end
    end

    context "when services are erroring" do
      before { servers_return_error }
      it "should raise the error" do
        expect {
          UpdateBuildWorker.new.perform(build)
        }.to raise_error
      end
    end
  end
end
