require 'spec_helper'

describe UpdateBuildWorker do
  describe "#perform" do
    let(:build) { new_parse_build }

    it "should update the build" do
      BuildFetcher.any_instance.should_receive(:fetch).and_return(build)
      ParseClient.any_instance.should_receive(:update).with(build)
      UpdateBuildWorker.new.perform(build)
    end

    context "for a build that just failed" do
      let(:build) { new_parse_build }
      let(:updated_build) { new_parse_build.merge("status" => "failed") }
      it "should notify the user of that failure" do
        BuildFetcher.any_instance.stub(:fetch).and_return(updated_build)
        ParseClient.any_instance.stub(:update)
        ParseClient.any_instance.should_receive(:notify_build_failed).with(updated_build)
        UpdateBuildWorker.new.perform(build)
      end
    end

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
