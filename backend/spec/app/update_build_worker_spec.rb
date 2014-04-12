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

      context "and the build branch changes" do
        let(:build) do
          build = new_parse_build
          build.branch = "new-branch"
          build
        end

        it "should push the change" do
          created_build = client.create(build)
          PusherClient.any_instance.should_receive(:push)
          UpdateBuildWorker.new.perform(created_build)
        end
      end

      context "and the build status changes" do
        let(:build) do
          build = new_parse_build
          build.status = "pending"
          build
        end

        it "should push the change" do
          created_build = client.create(build)
          PusherClient.any_instance.should_receive(:push)
          UpdateBuildWorker.new.perform(created_build)
        end
      end

      context "and the build status remains the same" do
        it "should not push the build" do
          created_build = client.create(build)
          PusherClient.any_instance.should_not_receive(:push)
          UpdateBuildWorker.new.perform(created_build)
        end
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
