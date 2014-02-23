require 'spec_helper'

describe UpdateBuildWorker do
  describe "#perform" do
    let(:build) { new_parse_build }
    it "should update the build" do
      BuildFetcher.any_instance.should_receive(:fetch).and_return(build)
      ParseClient.any_instance.should_receive(:update).with(build)
      UpdateBuildWorker.new.perform(build)
    end

    context "when services are healthy" do
      # unable to create a semaphore test server with expected builds
      # so force fakes here :(
      before { servers_return_healthy }
      it "should update the build" do
        ParseClient.from_settings.fetch_builds.should be_empty
        UpdateBuildWorker.new.perform(build)
        ParseClient.from_settings.fetch_builds.count.should == 1
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
